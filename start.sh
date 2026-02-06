#!/bin/bash
# Quick start script for the Spring Boot application with Docker

set -e

echo "==================================="
echo "Spring Boot Application Startup"
echo "==================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is running"

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found in current directory"
    exit 1
fi

echo "✅ docker-compose.yml found"

# Stop any existing containers
echo ""
echo "Stopping any existing containers..."
docker compose down -v 2>/dev/null || true

# Start services
echo ""
echo "Starting services (this may take 1-2 minutes on first run)..."
docker compose up -d

echo ""
echo "Waiting for services to be healthy..."
echo ""

# Wait for Oracle to be healthy
echo "⏳ Waiting for Oracle database..."
timeout=180
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose ps oracle | grep -q "healthy"; then
        echo "✅ Oracle database is ready"
        break
    fi
    sleep 5
    elapsed=$((elapsed + 5))
    echo "   Still waiting... ($elapsed seconds)"
done

# Wait for WireMock to be healthy
echo "⏳ Waiting for WireMock..."
timeout=60
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose ps wiremock | grep -q "healthy"; then
        echo "✅ WireMock is ready"
        break
    fi
    sleep 2
    elapsed=$((elapsed + 2))
done

# Wait for Spring Boot app to be healthy
echo "⏳ Waiting for Spring Boot application..."
timeout=120
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose ps springboot-app | grep -q "healthy"; then
        echo "✅ Spring Boot application is ready"
        break
    fi
    sleep 5
    elapsed=$((elapsed + 5))
    if [ $((elapsed % 20)) -eq 0 ]; then
        echo "   Still waiting... ($elapsed seconds)"
    fi
done

echo ""
echo "==================================="
echo "✅ All services are running!"
echo "==================================="
echo ""
echo "Service URLs:"
echo "  • Spring Boot App:     http://localhost:8090"
echo "  • Health Check:        http://localhost:8090/actuator/health"
echo "  • API Hello:           http://localhost:8090/api/hello"
echo "  • WireMock Test:       http://localhost:8090/api/wiremock-test"
echo "  • WireMock Admin:      http://localhost:8080/__admin"
echo "  • WireMock Health:     http://localhost:8080/__admin/health"
echo ""
echo "To view logs:"
echo "  docker compose logs -f"
echo ""
echo "To stop services:"
echo "  docker compose down"
echo ""
echo "To stop and remove volumes:"
echo "  docker compose down -v"
echo ""
