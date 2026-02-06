# Spring Boot 4 Application with Docker Setup

This is a Spring Boot application configured to run with Oracle Database and WireMock for API mocking.

## Prerequisites

- Docker and Docker Compose
- Java 17 (for local development without Docker)
- Maven 3.6+ (for local development without Docker)

## Project Structure

```
.
├── docker-compose.yml           # Docker Compose configuration
├── Dockerfile                   # Spring Boot app container
├── pom.xml                      # Maven project configuration
├── src/
│   ├── main/
│   │   ├── java/               # Java source files
│   │   └── resources/
│   │       └── application.yml # Application configuration
│   └── test/                   # Test files
└── wiremock/
    ├── mappings/               # WireMock stub mappings
    └── files/                  # WireMock response files
```

## Services

### Oracle Database
- **Image**: gvenzl/oracle-free:23-slim
- **Port**: 1521
- **Database**: appdb
- **Username**: appuser
- **Password**: apppass123

### WireMock
- **Image**: wiremock/wiremock:latest
- **Port**: 8080
- **Admin UI**: http://localhost:8080/__admin
- **Health**: http://localhost:8080/__admin/health

### Spring Boot Application
- **Port**: 8090
- **Health Check**: http://localhost:8090/actuator/health

## Quick Start

### 1. Start all services with Docker Compose

```bash
docker-compose up -d
```

This will start:
- Oracle database container
- WireMock container
- Spring Boot application container

### 2. Check service status

```bash
docker-compose ps
```

### 3. View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f springboot-app
docker-compose logs -f oracle
docker-compose logs -f wiremock
```

### 4. Test the application

```bash
# Application health check
curl http://localhost:8090/actuator/health

# WireMock health check
curl http://localhost:8080/__admin/health

# Test WireMock stub
curl http://localhost:8080/api/health
```

### 5. Stop services

```bash
docker-compose down
```

## Local Development (without Docker)

### 1. Start Oracle and WireMock containers only

```bash
docker-compose up -d oracle wiremock
```

### 2. Build and run the Spring Boot application locally

```bash
# Build
mvn clean install

# Run
mvn spring-boot:run
```

Or run directly with Java:

```bash
java -jar target/springboot-app-1.0.0.jar
```

## Configuration

### Application Properties

The application configuration is in `src/main/resources/application.yml`:

- Database connection settings
- JPA/Hibernate configuration
- Server port (8090)
- WireMock URL
- Logging levels
- Actuator endpoints

### Environment Variables

You can override configuration using environment variables:

```bash
export SPRING_DATASOURCE_URL=jdbc:oracle:thin:@localhost:1521/appdb
export SPRING_DATASOURCE_USERNAME=appuser
export SPRING_DATASOURCE_PASSWORD=apppass123
export WIREMOCK_URL=http://localhost:8080
```

## WireMock Configuration

### Adding New Stubs

Create JSON files in `wiremock/mappings/` directory:

```json
{
  "request": {
    "method": "GET",
    "url": "/api/example"
  },
  "response": {
    "status": 200,
    "headers": {
      "Content-Type": "application/json"
    },
    "jsonBody": {
      "message": "Hello from WireMock"
    }
  }
}
```

### Response Files

Place response files in `wiremock/files/` directory and reference them in mappings:

```json
{
  "response": {
    "status": 200,
    "bodyFileName": "example-response.json"
  }
}
```

## Database Management

### Connect to Oracle Database

```bash
# Using Docker exec
docker exec -it oracle-db sqlplus appuser/apppass123@//localhost:1521/appdb

# Using external SQL client
# Host: localhost
# Port: 1521
# Service: appdb
# User: appuser
# Password: apppass123
```

## Troubleshooting

### Oracle container not starting
- Wait for the health check to complete (can take 1-2 minutes on first start)
- Check logs: `docker-compose logs oracle`

### Application cannot connect to Oracle
- Ensure Oracle container is healthy: `docker-compose ps`
- Check connection string in application.yml
- Verify credentials

### WireMock stubs not loading
- Ensure mappings are in `wiremock/mappings/` directory
- Check JSON syntax
- View WireMock logs: `docker-compose logs wiremock`

## Cleanup

Remove all containers, volumes, and networks:

```bash
docker-compose down -v
```

## Notes

- **Spring Boot Version**: This project uses Spring Boot 3.2.2 (latest stable version, as Spring Boot 4 is not yet released)
- **Java Version**: Java 17 is required
- **Oracle Database**: Uses Oracle Free Edition (lightweight version)
- **First Start**: Oracle database initialization can take 1-2 minutes on first start

## Development Tips

1. **Hot Reload**: DevTools is included for automatic restarts during development
2. **Actuator**: Health and metrics endpoints are available at `/actuator`
3. **WireMock Admin**: Access WireMock admin UI at `http://localhost:8080/__admin`
4. **Database Persistence**: Oracle data is persisted in a Docker volume named `oracle-data`
