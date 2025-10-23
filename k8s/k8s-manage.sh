#!/bin/bash
# ==========================================
# k8s-manage.sh
# All-in-one Kubernetes management
# Stop/Start/Backup/Restore deployments & services across all namespaces
# ==========================================

BACKUP_DIR="./k8s-backups"
DATE=$(date +%Y%m%d-%H%M)
NAMESPACE_FILTER="$2"  # optional namespace argument
ACTION=$1              # e.g., --stop --start --save --restore

prepare_dir() {
  mkdir -p "$BACKUP_DIR"
}

get_namespaces() {
  if [ -n "$NAMESPACE_FILTER" ]; then
    echo "$NAMESPACE_FILTER"
  else
    kubectl get ns --no-headers -o custom-columns=":metadata.name" \
      | grep -vE 'kube-system|kube-public|kube-node-lease'
  fi
}

stop_all() {
  echo "🛑 Stopping all deployments..."
  prepare_dir
  for ns in $(get_namespaces); do
    echo "🔹 Namespace: $ns"
    NS_DIR="$BACKUP_DIR/${ns}_$DATE"
    mkdir -p "$NS_DIR"

    # Save replica counts
    kubectl get deploy -n $ns -o json | jq -r '.items[] | "\(.metadata.name):\(.spec.replicas)"' > "$NS_DIR/replicas.txt"

    # Scale deployments to 0
    for dep in $(kubectl get deploy -n $ns -o jsonpath='{.items[*].metadata.name}'); do
      echo "⏸️ Scaling down $dep..."
      kubectl scale deploy "$dep" --replicas=0 -n $ns
    done
    echo "✅ Namespace $ns stopped and replicas saved."
  done
}

start_all() {
  echo "🚀 Starting all deployments..."
  for dir in $BACKUP_DIR/*/; do
    ns=$(basename "$dir" | cut -d'_' -f1)
    # skip if filtering by namespace
    if [ -n "$NAMESPACE_FILTER" ] && [ "$ns" != "$NAMESPACE_FILTER" ]; then
      continue
    fi
    echo "🔹 Restoring namespace: $ns"
    kubectl get ns $ns >/dev/null 2>&1 || kubectl create ns $ns
    if [ -f "$dir/replicas.txt" ]; then
      while IFS=: read -r dep replicas; do
        if [ -n "$dep" ] && [ -n "$replicas" ]; then
          echo "🔼 Scaling $dep to $replicas replicas..."
          kubectl scale deploy "$dep" --replicas="$replicas" -n $ns
        fi
      done < "$dir/replicas.txt"
    fi
    echo "✅ Namespace $ns restored."
  done
}

save_all() {
  echo "💾 Saving all deployments & services..."
  prepare_dir
  for ns in $(get_namespaces); do
    echo "🔹 Backing up namespace: $ns"
    NS_DIR="$BACKUP_DIR/${ns}_$DATE"
    mkdir -p "$NS_DIR"

    kubectl get deploy -n $ns -o yaml > "$NS_DIR/deployments.yaml"
    kubectl get svc -n $ns -o yaml > "$NS_DIR/services.yaml"

    echo "✅ Namespace $ns saved."
  done
  echo "🎉 Backup complete in $BACKUP_DIR/"
}

restore_all() {
  echo "♻️ Restoring deployments & services..."
  for dir in $BACKUP_DIR/*/; do
    ns=$(basename "$dir" | cut -d'_' -f1)
    if [ -n "$NAMESPACE_FILTER" ] && [ "$ns" != "$NAMESPACE_FILTER" ]; then
      continue
    fi
    echo "🔹 Restoring namespace: $ns"
    kubectl get ns $ns >/dev/null 2>&1 || kubectl create ns $ns

    [ -f "$dir/deployments.yaml" ] && kubectl apply -n $ns -f "$dir/deployments.yaml"
    [ -f "$dir/services.yaml" ] && kubectl apply -n $ns -f "$dir/services.yaml"
    echo "✅ Namespace $ns restored from backup."
  done
  echo "🎉 Restore complete!"
}

# ---- MAIN ----
case $ACTION in
  --stop) stop_all ;;
  --start) start_all ;;
  --save) save_all ;;
  --restore) restore_all ;;
  *)
    echo "Usage: $0 --stop|--start|--save|--restore [optional-namespace]"
    exit 1
    ;;
esac
