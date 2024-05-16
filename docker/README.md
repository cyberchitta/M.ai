
# Deployment Instructions

This guide provides detailed instructions on how to deploy the application to a production server using Docker and Docker Compose.

## Steps to Deploy the Application

### 1. Clone the Repository

Clone the repository to the production server:

```sh
git clone <repository_url>
cd <repository_name>
```

### 2. Build the Docker Image

Navigate to the directory containing the Dockerfile and build the Docker image using the app name for the image:

```sh
docker build -t appname -f docker/supervisord.Dockerfile .
```

### 3. Copy the Docker Compose File

Copy the Docker Compose file to the `~/docker` folder where all compose files live:

```sh
mkdir -p ~/docker
cp docker/docker-compose.app.yml ~/docker/
```

### 4. Run the Database and Role Creation Script

Ensure the database service is running and create the necessary roles:

```sh
docker network create shared_network

# Start the database service
docker-compose -f docker/docker-compose.db.yml up -d

# Enter the database container
docker exec -it $(docker ps -qf "ancestor=postgres:15") bash

# Inside the container, create the postgres role
psql -U postgres -c "CREATE ROLE postgres WITH LOGIN SUPERUSER PASSWORD 'postgres';"

# Exit the container
exit
```

### 5. Create the `appname.env` File

Create an environment file for the application with the necessary environment variables:

```sh
cat <<EOF > ~/docker/appname.env
SECRET_KEY_BASE=your_secret_key_base
POSTGRES_HOST=db
PGPORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
OPENAI_API_KEY=your_openai_api_key
POOL_SIZE=10
EOF
```

### 6. Shared Environment Variables

Any shared environment variables should go into the `.env` file, which is visible by default. Create this file in the root directory of your repository:

```sh
cat <<EOF > .env
# Shared environment variables
PHX_IP=0.0.0.0
PHX_PORT=4000
EOF
```

### 7. Deploy the Application Service

Deploy the application service using Docker Compose:

```sh
docker-compose -f ~/docker/docker-compose.app.yml up -d
```

## Verifying the Deployment

1. **Check the Containers**:
   Verify that both the database and application containers are running:

   ```sh
   docker ps
   ```

2. **Network Configuration**:
   Ensure the services are on the correct network:

   ```sh
   docker network inspect shared_network
   ```

3. **Logs**:
   Check the logs to ensure both services are communicating correctly:

   ```sh
   docker-compose -f ~/docker/docker-compose.db.yml logs
   docker-compose -f ~/docker/docker-compose.app.yml logs
   ```

By following these steps, you should be able to deploy the application to a production server successfully. Make sure to replace placeholders such as `<repository_url>`, `<repository_name>`, and other environment variables with actual values.
