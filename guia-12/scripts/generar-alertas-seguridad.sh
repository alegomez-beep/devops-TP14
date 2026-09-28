#!/bin/bash
set -euo pipefail

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null || echo "127.0.0.1")
INGRESS_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}' 2>/dev/null || echo "30080")
URL="http://$NODE_IP:$INGRESS_PORT"

echo "=========================================================="
echo "  SIMULACIÓN DE ATAQUE / TRÁFICO ANÓMALO (TP12C)"
echo "=========================================================="
echo "Objetivo: $URL"
echo ""

echo "[1/2] Generando escaneo de rutas inexistentes (provocando errores HTTP 404/403)..."
for i in {1..50}; do
  curl -s -o /dev/null -w "%{http_code}\n" -H "Host: notes.local" "$URL/admin-admin-$i" || true
done

echo ""
echo "[2/2] Simulando fuerza bruta de login (provocando errores HTTP 401)..."
for i in {1..30}; do
  curl -s -o /dev/null -w "%{http_code}\n" -X POST -H "Host: notes.local" "$URL/api/v1/login" -d '{"user":"admin","pass":"wrong"}' || true
done

echo ""
echo "=== Simulación completada ==="
