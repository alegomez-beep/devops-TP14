# TP12C - Monitoreo y Alertas de Seguridad en Prometheus

## Descripción
Configuración de alertas de seguridad (`IngressPicoErrores4xx5xx` e `InvasionIntentosAuthFallidos`) en Prometheus para el clúster K3s.

## Verificación de Alertas Activas
Resultado obtenido al validar con la API de Prometheus (`/api/v1/alerts`):

```json
{
  "status": "success",
  "data": {
    "alerts": [
      {
        "labels": {
          "alertname": "IngressPicoErrores4xx5xx",
          "severity": "critical"
        },
        "state": "pending"
      },
      {
        "labels": {
          "alertname": "InvasionIntentosAuthFallidos",
          "severity": "warning"
        },
        "state": "pending"
      }
    ]
  }
}
