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

# Crear un secret generico
kubectl create secret generic app-secrets \
  --from-literal=postgres-user="$(grep '^POSTGRES_USER=' .env | cut -d'=' -f2-)" \
  --from-literal=postgres-password="$(grep '^POSTGRES_PASSWORD=' .env | cut -d'=' -f2-)" \
  --from-literal=postgres-db="$(grep '^POSTGRES_DB=' .env | cut -d'=' -f2-)" \
  --from-literal=db-user="$(grep '^DB_USER=' .env | cut -d'=' -f2-)" \
  --from-literal=db-password="$(grep '^DB_PASSWORD=' .env | cut -d'=' -f2-)" \
  --from-literal=db-name="$(grep '^DB_NAME=' .env | cut -d'=' -f2-)" \
  --from-literal=salt-rounds="$(grep '^SALT_ROUNDS=' .env | cut -d'=' -f2-)" \
  --from-literal=jwt-secret="$(grep '^JWT_SECRET=' .env | cut -d'=' -f2-)" \
  -n localicity-app --dry-run=client -o yaml | kubectl apply -f -