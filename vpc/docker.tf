resource "local_file" "docker_compose" {
  filename = "${path.module}/docker-compose.yml"
  content  = <<-EOT
version: '3.8'

services:
  db:
    image: postgres:13-alpine
    environment:
      POSTGRES_DB: horilla
      POSTGRES_USER: horilla
      POSTGRES_PASSWORD: horilla123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: always

  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    ports:
      - "8000:8000"
    environment:
      DB_HOST: db
      DB_NAME: horilla
      DB_USER: horilla
      DB_PASS: horilla123
    depends_on:
      - db
    restart: always

  frontend:
    build:
      context: .
      dockerfile: Dockerfile.frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: always

volumes:
  postgres_data:
EOT
}
