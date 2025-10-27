# Crear namespace
kubectl apply -f namespace.yaml

# Crear secrets (primero codifica tus valores)
echo -n "tu_usuario" | base64
echo -n "tu_password" | base64
# ... luego aplica:
kubectl apply -f secrets.yaml

# Aplicar configmaps
kubectl apply -f configmap.yaml

# Aplicar todos los servicios
kubectl apply -f postgresql.yaml
kubectl apply -f api-deployment.yaml
kubectl apply -f astro-deployment.yaml
kubectl apply -f nginx-deployment.yaml

# Verificar el estado
kubectl get all -n localicity-app

# Obtener la IP externa del nginx
kubectl get service nginx-service -n localicity-app