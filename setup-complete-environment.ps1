# Complete inSwing Development Environment Setup
# Run this script to install all dependencies

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

function Install-DockerDesktop {
    Write-Status "Installing Docker Desktop..." "Info"
    
    try {
        # Check if Docker is already installed
        $dockerCheck = Get-Command docker -ErrorAction SilentlyContinue
        if ($dockerCheck) {
            Write-Status "Docker is already installed: $(docker --version)" "Success"
            return $true
        }
        
        Write-Status "Docker Desktop not found. Please install it manually." "Warning"
        Write-Status "Download from: https://www.docker.com/products/docker-desktop/" "Info"
        Write-Status "Or from Microsoft Store: Search for 'Docker Desktop'" "Info"
        
        # Open browser to download page
        Start-Process "https://www.docker.com/products/docker-desktop/"
        
        Write-Status "Please install Docker Desktop and run this script again." "Warning"
        return $false
    }
    catch {
        Write-Status "Error checking Docker: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Setup-PythonEnvironment {
    Write-Status "Setting up Python environment..." "Info"
    
    try {
        # Check Python version
        $pythonVersion = python --version
        Write-Status "Python version: $pythonVersion" "Success"
        
        # Create virtual environment
        if (Test-Path "venv") {
            Write-Status "Virtual environment already exists" "Info"
        } else {
            python -m venv venv
            Write-Status "Created virtual environment" "Success"
        }
        
        # Activate virtual environment
        .\venv\Scripts\Activate
        
        # Upgrade pip
        python -m pip install --upgrade pip
        Write-Status "Upgraded pip" "Success"
        
        # Install requirements
        if (Test-Path "requirements.txt") {
            pip install -r requirements.txt
            Write-Status "Installed Python dependencies" "Success"
        } else {
            Write-Status "requirements.txt not found, installing basic packages..." "Warning"
            pip install fastapi uvicorn sqlalchemy pymysql redis python-jose passlib bcrypt python-multipart alembic celery python-dotenv sentry-sdk
        }
        
        return $true
    }
    catch {
        Write-Status "Error setting up Python environment: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Setup-FlutterEnvironment {
    Write-Status "Setting up Flutter environment..." "Info"
    
    try {
        # Check Flutter
        $flutterVersion = flutter --version
        Write-Status "Flutter version: $flutterVersion" "Success"
        
        # Get Flutter packages
        if (Test-Path "flutter/pubspec.yaml") {
            Set-Location flutter
            flutter pub get
            Set-Location ..
            Write-Status "Flutter packages installed" "Success"
        } else {
            Write-Status "Flutter project not found" "Warning"
        }
        
        return $true
    }
    catch {
        Write-Status "Error setting up Flutter: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Start-DevelopmentServices {
    Write-Status "Starting development services..." "Info"
    
    try {
        # Check if docker-compose.yml exists
        if (-not (Test-Path "docker-compose.yml")) {
            Write-Status "docker-compose.yml not found. Creating default setup..." "Warning"
            
            # Create a basic docker-compose.yml
            @"
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: inswing-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword123
      MYSQL_DATABASE: inswing
      MYSQL_USER: inswing_user
      MYSQL_PASSWORD: inswing_password123
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password

  redis:
    image: redis:7.0-alpine
    container_name: inswing-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes --requirepass redis_password123

volumes:
  mysql_data:
  redis_data:
"@ | Out-File -FilePath "docker-compose.yml" -Encoding UTF8
        }
        
        # Start services
        docker-compose up -d
        Write-Status "Development services started" "Success"
        
        # Wait for services to initialize
        Write-Status "Waiting for services to initialize..." "Info"
        Start-Sleep -Seconds 30
        
        return $true
    }
    catch {
        Write-Status "Error starting services: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-Connections {
    Write-Status "Testing service connections..." "Info"
    
    try {
        # Test MySQL
        $mysqlTest = docker exec inswing-mysql mysql -u inswing_user -pinswing_password123 -e "SELECT 1;" inswing 2>$null
        if ($mysqlTest) {
            Write-Status "MySQL connection successful" "Success"
        } else {
            Write-Status "MySQL connection failed - service may still be starting" "Warning"
        }
        
        # Test Redis
        $redisTest = docker exec inswing-redis redis-cli -a redis_password123 ping 2>$null
        if ($redisTest -eq "PONG") {
            Write-Status "Redis connection successful" "Success"
        } else {
            Write-Status "Redis connection failed - service may still be starting" "Warning"
        }
        
        return $true
    }
    catch {
        Write-Status "Connection test error: $($_.Exception.Message)" "Warning"
        return $true  # Don't fail setup for connection tests
    }
}

function Create-EnvironmentFile {
    Write-Status "Creating environment configuration file..." "Info"
    
    try {
        if (Test-Path ".env") {
            Write-Status ".env file already exists" "Info"
            return $true
        }
        
        # Copy from .env.example if it exists
        if (Test-Path ".env.example") {
            Copy-Item ".env.example" ".env"
            Write-Status "Created .env from .env.example" "Success"
        } else {
            # Create basic .env file
            @"
# Database
DATABASE_URL=mysql://inswing_user:inswing_password123@localhost:3306/inswing

# Redis
REDIS_URL=redis://:redis_password123@localhost:6379/0

# JWT
JWT_SECRET_KEY=your-secret-key-change-this-in-production

# Environment
ENVIRONMENT=development
DEBUG=true
"@ | Out-File -FilePath ".env" -Encoding UTF8
            Write-Status "Created basic .env file" "Success"
        }
        
        return $true
    }
    catch {
        Write-Status "Error creating .env file: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Show-NextSteps {
    Write-Host ""
    Write-Host "${GREEN}🎉 Development Environment Setup Complete!${RESET}"
    Write-Host "============================================="
    Write-Host ""
    Write-Host "${BLUE}Services Running:${RESET}"
    Write-Host "  • MySQL: localhost:3306"
    Write-Host "  • Redis: localhost:6379"
    Write-Host ""
    Write-Host "${BLUE}Environment:${RESET}"
    Write-Host "  • Python venv: .\venv\Scripts\Activate"
    Write-Host "  • Environment file: .env"
    Write-Host ""
    Write-Host "${BLUE}Next Steps:${RESET}"
    Write-Host "  1. Activate Python environment: .\venv\Scripts\Activate"
    Write-Host "  2. Create backend folder structure"
    Write-Host "  3. Initialize database: alembic upgrade head"
    Write-Host "  4. Start FastAPI server: uvicorn app.main:app --reload"
    Write-Host "  5. Setup Flutter project: cd flutter && flutter pub get"
    Write-Host ""
    Write-Host "${BLUE}Useful Commands:${RESET}"
    Write-Host "  • Start services: docker-compose up -d"
    Write-Host "  • Stop services: docker-compose down"
    Write-Host "  • View logs: docker-compose logs -f"
    Write-Host "  • Check status: docker-compose ps"
    Write-Host ""
    Write-Host "${GREEN}Ready to start building inSwing! 🚀${RESET}"
}

# Main execution
Write-Host "${GREEN}🚀 inSwing Complete Development Environment Setup${RESET}"
Write-Host "====================================================="
Write-Host ""

# Step 1: Install Docker Desktop
Write-Status "Step 1: Installing Docker Desktop..." "Info"
if (-not (Install-DockerDesktop)) {
    Write-Status "Docker Desktop installation required. Please install and run again." "Error"
    exit 1
}

# Step 2: Setup Python environment
Write-Status "Step 2: Setting up Python environment..." "Info"
if (-not (Setup-PythonEnvironment)) {
    Write-Status "Python environment setup failed." "Error"
    exit 1
}

# Step 3: Setup Flutter environment
Write-Status "Step 3: Setting up Flutter environment..." "Info"
if (-not (Setup-FlutterEnvironment)) {
    Write-Status "Flutter environment setup failed." "Warning"
    # Don't exit, continue with other setup
}

# Step 4: Start development services
Write-Status "Step 4: Starting development services..." "Info"
if (-not (Start-DevelopmentServices)) {
    Write-Status "Failed to start development services." "Error"
    exit 1
}

# Step 5: Test connections
Write-Status "Step 5: Testing service connections..." "Info"
Test-Connections

# Step 6: Create environment file
Write-Status "Step 6: Creating environment configuration..." "Info"
if (-not (Create-EnvironmentFile)) {
    Write-Status "Environment file creation failed." "Warning"
}

# Show next steps
Show-NextSteps