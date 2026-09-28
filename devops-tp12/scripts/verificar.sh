#!/bin/bash
set -euo pipefail

# Determinar cuál puerto está activo (9090 o 9095)
PORT="9090"
if ! curl -s "http://localhost:9090/api/v1/alerts" >/dev/null 2>&1; then
  PORT="9095"
fi

echo "=========================================================="
echo "      VERIFICACIÓN DE ALERTAS DE SEGURIDAD (TP12C)       "
echo "=========================================================="
echo "Consultando Prometheus en http://localhost:$PORT ..."
echo ""

curl -s "http://localhost:$PORT/api/v1/alerts" | python3 -m json.tool || true
