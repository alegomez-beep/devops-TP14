#!/bin/bash
set -uo pipefail

NS="devops-portfolio"
ERRORS=0

ok()   { echo "  [OK]   $1"; }
fail() { echo "  [FAIL] $1"; ERRORS=$((ERRORS+1)); }

echo "================================================="
echo "  VERIFICACIÓN HELM & INGRESS (TP10B - RENDER)"
echo "================================================="
echo ""

echo "--- 1. Validación de Renderizado (Render First) ---"
if helm template test-release ./devops-portfolio -f values-prod.yaml > /tmp/test-rendered.yaml 2>/dev/null; then
  ok "Renderizado de plantillas Go completado exitosamente"
  if python3 -c "import yaml; list(yaml.safe_load_all(open('/tmp/test-rendered.yaml')))" 2>/dev/null; then
    ok "Sintaxis YAML del manifiesto renderizado correcta (sin falsos positivos)"
  else
    fail "Error de sintaxis en el YAML renderizado"
  fi
else
  fail "Error al ejecutar helm template"
fi

echo ""
echo "--- 2. Pods en Kubernetes ---"
kubectl get pods -n $NS --no-headers 2>/dev/null | while read line; do
  NAME=$(echo $line   | awk '{print $1}')
  STATUS=$(echo $line | awk '{print $3}')
  READY=$(echo $line  | awk '{print $2}')
  if [ "$STATUS" = "Running" ] || [ "$STATUS" = "Completed" ]; then
    ok "$NAME -> $STATUS ($READY)"
  else
    fail "$NAME -> $STATUS ($READY)"
  fi
done

echo ""
echo "--- 3. Ingress y Enrutamiento Capa 7 ---"
kubectl get ingress -n $NS --no-headers 2>/dev/null | while read line; do
  NAME=$(echo $line | awk '{print $1}')
  HOST=$(echo $line | awk '{print $3}')
  ok "Ingress '$NAME' configurado para host: $HOST"
done

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "=== TP10B OK: Todos los checks pasaron correctamente ==="
else
  echo "=== ATENCIÓN: $ERRORS checks fallaron ==="
fi
