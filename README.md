# Caso Práctico sobre Kubernetes

## Inicialización de un clúster

El primer paso a realizar es el inicializar un clúster el cual alojara todos los nodos que querramos mantener en ejecución dentro de él.

### 1. Requisitos Previos

Antes de empezar, necesitas tener instaladas dos cosas en tu sistema operativo (Windows, macOS o Linux):

1. **kubectl:** La herramienta de línea de comandos de Kubernetes. Es esencial para interactuar con el clúster una vez que esté funcionando.
2. **Un entorno de virtualización o contenedorización:** Minikube necesita una forma de ejecutar el nodo de Kubernetes. El método más fácil es usar **Docker**. Asegúrate de que **Docker esté instalado y ejecutándose**.

### 2. Instalar Minikube

Descarga e instala el binario de Minikube. La forma más común es a través de gestores de paquetes o descargándolo directamente.

#### Comando de Instalación (Ejemplos)

| **Linux** | **`curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/`** |
| --- | --- |
| **Windows** | `winget install Kubernetes.minikube` |
| **macOS** | `brew install minikube` |

> [!TIP]
> **Alternativa:**
> - Si no te funcionan los comandos anteriores, intenta ejecutar este comando desde tu terminal con **`Bash`**.
>  ```bash
> # get Windows username reliably
> USERNAME=$(whoami | sed 's/.*\\//')
> mkdir -p "/c/Users/$USERNAME/bin"
> mv [minikube-windows-amd64.exe](http://_vscodecontentref_/0) "/c/Users/$USERNAME/bin/minikube.exe"
> # ensure path: add C:\Users\<you>\bin to Windows user PATH via PowerShell or Windows UI
> /c/Windows/System32/cmd.exe /c "setx PATH \"%PATH%;C:\\Users\\$USERNAME\\bin\""
> # close and reopen shells, then verify
> minikube version
> ```

### 3. Iniciar el Clúster

Una vez que tengas Minikube y Docker instalados, puedes iniciar tu clúster con un solo comando. Usaremos el *driver* de Docker, que es el más rápido.

1. **Inicia Minikube:**
    
    ```bash
    minikube start --driver=docker
    ```
    
    - Este comando descarga la imagen de Kubernetes y configura un clúster de un solo nodo dentro de un contenedor de Docker. El proceso puede tardar unos minutos la primera vez.
2. **Verifica el estado:**
    
    ```bash
    kubectl get nodes
    ```
    
    Deberías ver una salida similar a esta, confirmando que tu nodo está listo (`Ready`):
    
    ```bash
    NAME       STATUS   ROLES           AGE   VERSION
    minikube   Ready    control-plane   2m    v1.28.3
    ```
    

### 4. Próximos Pasos (Opcional)

Una vez que el clúster esté iniciado, puedes empezar a trabajar con él.

- **Ver el Dashboard:** Kubernetes tiene una interfaz gráfica web. Puedes abrirla fácilmente:
    
    ```bash
    minikube dashboard
    ```
    
- **Desplegar tu primer recurso:** Ahora que el clúster está listo, puedes usar el comando que te expliqué antes (`kubectl apply -f mi-recurso.yaml`) para crear un recurso como un `Deployment` o un `Pod`.

Para poder manipular Kubernetes necesitamos el siguiente comando:

```bash
kubectl
```

Ejecutando unicamente ese comando obtendremos la información de todas las cosas que se pueden realizar con ese comando, como crear un recurso, configurarlo, etc.

## Ejecución de los servicios

Para ejecutar nuestros servicios, debemos ejecutar el siguiente comando

```bash
./init.sh
```

## Variables de entorno

Lo primero sera crear un archivo **`.env`** para guardar 

### Ejemplo de `.env`:

```bash
#_________NodeJS__________
NODE_ENV=production

#________ExpressJS________
EXPRESS_PORT=3000

#________Astro________
ASTRO_PORT=4321

#__________CORS___________
CORS_ORIGIN=http://tu-dominio.com

#__________Nginx__________
NGINX_PORT=80

#______JsonWebToken_______
JWT_SECRET=tu-jwt-secreto

#_________TypeORM_________
DB_USER=usuario
DB_PASSWORD=contraseña
DB_NAME=localicity

POSTGRES_USER=usuario
POSTGRES_PASSWORD=contraseña
POSTGRES_DB=localicity
POSTGRES_PORT=5432

#_________Bcrypt__________
SALT_ROUNDS=5
```

Para crear las variables de entorno que posteriormente utilizaran nuestro recursos utilizamos los siguientes comandos (suponiendo que ya existe el archivo **`.env`**):

```bash
# desde el directorio donde está .env
kubectl delete secret app-secrets -n localicity-app 2>/dev/null || true
kubectl create secret generic app-secrets --from-env-file=.env -n localicity-app
kubectl get secret app-secrets -n localicity-app -o yaml
```

Luego ejecutamos el siguiente script para reiniciar el deployment\

```bash
kubectl rollout restart deployment api -n localicity-app
kubectl get pods -n localicity-app -w
```

## Exposición del servicio

Para exponer el servicio debemos ejecutar el siguiente comando:

```bash
./expose-nginx-local
```
