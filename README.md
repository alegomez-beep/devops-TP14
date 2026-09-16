# TP14 — Modelado de amenazas con Threagile

## Objetivo

En esta guía vas a integrar Threagile al pipeline de CI/CD de la Notes App. El objetivo es describir la arquitectura que construiste hasta TP12, analizar sus riesgos y generar un reporte actualizado cada vez que cambie el modelo.

Threagile es una herramienta de modelado de amenazas. La arquitectura se escribe en un archivo YAML que se guarda junto con el código. De esta manera, el modelo puede validarse en la computadora del alumno y también desde GitHub Actions.

## Prerrequisitos

- Docker, Git, Python 3 con PyYAML y un repositorio de GitHub configurado.
- Base integrada hasta TP12. Su preparación completa, TLS y comprobaciones están en [`devops-tp12/README.md`](devops-tp12/README.md).
- Pipeline previo en `.github/workflows/cicd.yml`.

Esta versión fue comprobada con Threagile 1.0.0. Los identificadores de riesgo pueden cambiar entre versiones; por eso se obtienen de la primera ejecución y no se escriben de memoria.

## Mapa de carpetas

```text
raíz-del-repositorio/             # ejecutar Git y editar .github aquí
├── .github/workflows/cicd.yml
├── .yamllint.yml                 # reglas usadas por el job de lint
├── devops-tp12/                 # proyecto integrado y modelo TP14
│   ├── app/ chart/ scripts/
│   └── threagile.yaml           # lo crearás; no viene resuelto
├── devops-TP06/                 # copia histórica usada por jobs previos
├── guia-06/                     # Docker Compose
├── guia-08/                     # Prometheus y Grafana
├── guia-09/                     # Kubernetes
├── guia-10/                     # Helm e Ingress
├── guia-11/                     # Terraform
└── guia-12/                     # portfolio integrado
```

### Funcionalidades e Integración
* **Modelo de Arquitectura (`devops-tp12/threagile.yaml`):** Definición declarativa de los activos de datos (notas, credenciales, métricas), activos técnicos (Ingress, Nginx, Flask Backend, PostgreSQL, Prometheus, Grafana, API Server) y enlaces de comunicación con sus respectivos protocolos.
* **Evaluación de Riesgos y Risk Tracking:** Identificación automática de vectores de ataque (SQLi, XSS, Path Traversal, comunicación no cifrada) y gestión de excepciones aceptadas para el entorno de laboratorio local.
* **Automatización en GitHub Actions:** Adición del job `threat-modeling` en `.github/workflows/cicd.yml` que ejecuta Threagile en cada integración y publica el reporte PDF y el diagrama de flujo de datos (DFD) como artefacto descargable (`threagile-report`).
