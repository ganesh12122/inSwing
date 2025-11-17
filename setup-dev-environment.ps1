# Development Environment Setup Script
# Run this script after Docker Desktop is installed

# Colors for output
$GREEN = "`e[32m"
$RED = "`e[31m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$RESET = "`e[0m"

function Write-Status {
    param(
        [string]$Message,
        [string]$Status
    )
    
    switch ($Status) {
        "Success" { Write-Host "${GREEN}✅ $Message${RESET}" }
        "Error" { Write-Host "${RED}❌ $Message${RESET}" }
        "Warning" { Write-Host "${YELLOW}⚠️  $Message${RESET}" }
        "Info" { Write-Host "${BLUE}ℹ️  $Message${RESET}" }
        default { Write-Host $Message }
    }
}

function Test-Docker {
    try {
        $dockerVersion = docker --version
        Write-Status "Docker is installed: $dockerVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Docker is not installed or not in PATH" "Error"
        return $false
    }
}

function Test-DockerCompose {
    try {
        $composeVersion = docker-compose --version
        Write-Status "Docker Compose is installed: $composeVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Docker Compose is not available" "Error"
        return $false
    }
}

function Install-PythonDependencies {
    Write-Status "Installing Python dependencies for FastAPI..." "Info"
    
    try {
        # Create virtual environment
        python -m venv venv
        Write-Status "Created Python virtual environment" "Success"
        
        # Activate virtual environment
        .\venv\Scripts\Activate
        
        # Install dependencies
        pip install --upgrade pip
        pip install fastapi uvicorn sqlalchemy pymysql redis python-jose passlib bcrypt python-multipart alembic celery
        
        Write-Status "Python dependencies installed successfully" "Success"
        return $true
    }
    catch {
        Write-Status "Failed to install Python dependencies: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Start-DevelopmentServices {
    Write-Status "Starting development services (MySQL + Redis)..." "Info"
    
    try {
        docker-compose up -d
        Write-Status "Development services started successfully" "Success"
        
        # Wait for services to be ready
        Write-Status "Waiting for services to be ready..." "Info"
        Start-Sleep -Seconds 30
        
        return $true
    }
    catch {
        Write-Status "Failed to start development services: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-Connections {
    Write-Status "Testing database and Redis connections..." "Info"
    
    try {
        # Test MySQL connection
        $mysqlTest = docker exec inswing-mysql mysql -u inswing_user -pinswing_password123 -e "SELECT 1;" inswing 2>$null
        if ($mysqlTest) {
            Write-Status "MySQL connection successful" "Success"
        } else {
            Write-Status "MySQL connection failed" "Error"
        }
        
        # Test Redis connection
        $redisTest = docker exec inswing-redis redis-cli -a redis_password123 ping 2>$null
        if ($redisTest -eq "PONG") {
            Write-Status "Redis connection successful" "Success"
        } else {
            Write-Status "Redis connection failed" "Error"
        }
        
        return $true
    }
    catch {
        Write-Status "Connection tests failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Show-EnvironmentInfo {
    Write-Status "Development Environment Information:" "Info"
    Write-Host ""
    Write-Host "${BLUE}Services:${RESET}"
    Write-Host "  • MySQL: localhost:3306 (user: inswing_user, pass: inswing_password123)"
    Write-Host "  • Redis: localhost:6379 (password: redis_password123)"
    Write-Host "  • Redis UI: http://localhost:8081"
    Write-Host "  • MySQL UI: http://localhost:8082"
    Write-Host ""
    Write-Host "${BLUE}Commands:${RESET}"
    Write-Host "  • Start services: docker-compose up -d"
    Write-Host "  • Stop services: docker-compose down"
    Write-Host "  • View logs: docker-compose logs -f"
    Write-Host "  • Restart services: docker-compose restart"
    Write-Host ""
    Write-Host "${BLUE}Next Steps:${RESET}"
    Write-Host "  1. Update your .env file with the database credentials"
    Write-Host "  2. Install Python dependencies: pip install -r requirements.txt"
    Write-Host "  3. Run database migrations: alembic upgrade head"
    Write-Host "  4. Start the FastAPI server: uvicorn app.main:app --reload"
    Write-Host ""
}

# Main execution
Write-Host "${GREEN}🚀 inSwing Development Environment Setup${RESET}"
Write-Host "============================================="
Write-Host ""

# Check Docker
Write-Status "Checking Docker installation..." "Info"
if (-not (Test-Docker)) {
    Write-Status "Please install Docker Desktop first!" "Error"
    Write-Status "Download from: https://www.docker.com/products/docker-desktop/" "Info"
    exit 1
}

# Check Docker Compose
Write-Status "Checking Docker Compose..." "Info"
if (-not (Test-DockerCompose)) {
    Write-Status "Docker Compose not found. It should be included with Docker Desktop." "Error"
    exit 1
}

# Start development services
Write-Status "Setting up development services..." "Info"
if (Start-DevelopmentServices) {
    # Test connections
    Test-Connections
    
    # Show environment info
    Show-EnvironmentInfo
    
    Write-Status "Development environment setup complete! 🎉" "Success"
} else {
    Write-Status "Setup failed. Please check Docker and try again." "Error"
    exit 1
}

Write-Host "${GREEN}Setup complete! You can now proceed with building inSwing.${RESET}"