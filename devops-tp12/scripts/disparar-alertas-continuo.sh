#!/bin/bash
set -euo pipefail

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null || echo "127.0.0.1")
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}' 2>/dev/null || echo "30080")
URL="http://$NODE_IP:$INGRESS_PORT"

echo "=========================================================="
echo "  GENERANDO ERRORES 404/401 MASIVOS EN TIEMPO REAL"
echo "=========================================================="
echo "Inyectando 300 peticiones erróneas..."

# Ráfaga masiva para forzar rate > 5 req/sec en Ingress
for i in {1..300}; do
  curl -s -o /dev/null -H "Host: ruta-inexistente-$i.local" "$URL/no-existe-$i" || true
done

echo ""
echo "=== Ráfaga completada ==="
