# PRACTICA_FINAL

## Requisitos:

### Crear credenciales en AWS:
 * Dentro de AWS, tienes que ir a tu nombre y pinchar en Credenciales de Seguridad
 * Después pincha en Claves de acceso (ID de clave de acceso y clave de acceso secreta)
 * Crear una clave de acceso
 * Descargar (Acuérdate bien donde la guardas porque la necesitarás para meterla en Jenkins...)

### Jenkins:
 * Tendrás un docker-compose en la carpeta PRÁCTICA_FINAL, sólo tienes que correr en el terminal:

    ```
        docker-compose up
    ```
 * Una vez que hayas hecho esto tendrás que copiar la contraseña que te sale en ese mismo terminal.
 * Cuando tengas la contraseña puedes ir a http://localhost:8080 e introducirla.
 * A partir de aquí tendrás que rellenar campos como nombre, contraseña, mail, etc...
 * Una vez hecho esto, Jenkins te ofrecerá la posibilidad de instalar una serie de plugins, los imprescindibles son:
        -Plugins iniciales
 * Cuando Jenkins haya instalado todos los plugins y te deje entrar a la interfaz, necesitarás dos plugins más: Job DSL y Docker
 * Una vez instalados, tienes que ir a new item (lo puedes llamar 0.seed y freestyle project)
 * Cuando esté creado, puedes activar timestamps e ir a build y seleccionar proccess job dsl, marcas la casilla use the provider DSL script y pegas el DSL en el campo de texto - Gurdas - Construir ahora.
 * Hecho esto te aparecerán dos Jobs nuevos: Infraestructura_despliegue y almacenamiento_control.

### Guardar credenciales AWS en Jenkins:
 * Dentro de Manage Jenkins, pinchar en Manage Credentials
 * Dentro de Stores Scoped to Jenkins pinchar en Jenkins, te llevara a System
 * En System pinchas en global credentials y en el menú de la izquierda pinchas en add credentials, donde meteras las credenciales que te has descargado en el primer requisito.

### Docker:
 * En la pestaña gestionar Jenkins (Manage Jenkins), seleccionamos Manage Nodes and Clouds, después Configure Clouds y creamos una nube nueva, te saldrá Docker gracias al plugin que instalamos antes.
 * Llegados a este punto, si no tienes que habilitar la API de Docker tendrás que hacerlo... (https://onthedock.github.io/post/170506-habilita-el-acceso-remoto-via-api-a-docker/)
 * Una vez habilitada podrás hacer el test connection despues de añadir el docker host (tcp://ipDocker:puertoDocker), que consiste en la IP de docker y el puerto que hayas añadido, en mi caso fue el 4243
 * Cuando hayas pasado el test connection será hora de añadir el terraform agent:
    - Label: terraform
    - Name: terraform
    - Docker Image: oliverp83/terraform-jenkins-agent
    - Remote File System Root: /home/jenkins
    - Usage: Only build jobs with label expressions matching this node
    - Connect Method: Connect with SSH
        - SSH Key: Use configured SSH credentials
            - SSH Credentials: Add (jenkins/jenkins) (También se recomienda guardar estas credenciales en Manage Credentials)
        - Host Key Verification Strategy: non verifying verification strategy
    - Pull strategy: Pull all images every time
    - Save
 * Ya podrías construir dentro de Jenkins tanto Infraestructura_despliegue como almacenamiento_control

## Makefile
 * Puedes correr el makefile en local por pasos (ej: `make clean`) o utilizando el siguiente comando:

    ```
        make all
    ```
## Archivos proyecto (falta ghactions)
 * .github/workflows: Aquí se encuentra el terraform.yaml para desplegar usando ghactions.
 * agents: En esta carpeta se encuentran los agentes de Jenkins:
    - base.Dockerfile: que contiene todo lo necesario: ubuntu, java, openssh...
    - terraform.Dockerfile: que contiene terraform, aws-cli, curl...
 * infraestructura: Esta carpeta contiene el main.tf necesario para construir la infraestructura en aws
 * docker-compose.yaml: para acceder a jenkins en local
 * DSL: para crear los jobs de Jenkins
 * Jenkinsfiles: Para desplegar con terraform usando Jenkins(Jenkinsfile.despliegue) y para hacer el control de la memoria que usa el bucket de aws(Jenkinsfile.control)
 * Makefile: Para que los desarrolladores puedan desplegar la infraestructura (cambiar a desarrollo, lo tienes en producción)

 ## Probando este pipeline en Jenkinsfile.control

```
        stage ('Control - dev') {
            steps {
                sh '''
                    ALMACENAMIENTO=$(aws s3 ls s3://practica-final-cicd-dev --recursive --summarize | tail -1 | cut -d : -f 2) && \
                    [[ "${ALMACENAMIENTO}" -gt "${SIZE}" ]] && \
                    aws s3 rm s3://practica-final-cicd-dev --recursive             
                '''
                }
                when
                expression {aws s3 ls s3://practica-final-cicd-dev --recursive --summarize | tail -1 | cut-d : -f 2) -gt ${SIZE} ]] && \
                aws s3 rm s3://practica-final-cicd-dev --recursive
        }
```
