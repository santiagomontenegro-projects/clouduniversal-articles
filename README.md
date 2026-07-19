# clouduniversal-articles

Colección de ejemplos de Infraestructura como Código (IaC) para distintos proveedores cloud.

## Estructura

```
aws/
azure/
  bicep_iac/
    main.bicep
gcp/
  terraform_gcp/
    main.tf
    variables.tf
    outputs.tf
    providers.tf
    terraform.tfvars.example
```

## aws/

Carpeta reservada para ejemplos de AWS. Actualmente vacía.

## azure/bicep_iac/

- **main.bicep** — Plantilla Bicep que despliega una máquina virtual Linux en Azure junto con su red asociada: grupo de seguridad de red (NSG con regla SSH), IP pública, red virtual/subred, interfaz de red y la propia VM.

## gcp/terraform_gcp/

- **providers.tf** — Configuración del proveedor de Terraform para Google Cloud y versión mínima requerida.
- **variables.tf** — Definición de variables de entrada (proyecto, región, nombre del bucket).
- **main.tf** — Recurso principal: un bucket de Cloud Storage.
- **outputs.tf** — Salidas del módulo (nombre y URL del bucket creado).
- **terraform.tfvars.example** — Ejemplo de valores para las variables, a copiar como `terraform.tfvars`.
