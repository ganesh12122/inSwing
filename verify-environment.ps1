# Environment Verification Script for inSwing
# Run this to verify all dependencies are properly installed

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
        Write-Status "Docker: $dockerVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Docker not installed or not in PATH" "Error"
        return $false
    }
}

function Test-DockerCompose {
    try {
        $composeVersion = docker-compose --version
        Write-Status "Docker Compose: $composeVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Docker Compose not available" "Error"
        return $false
    }
}

function Test-Flutter {
    try {
        $flutterVersion = flutter --version
        Write-Status "Flutter: Installed" "Success"
        return $true
    }
    catch {
        Write-Status "Flutter not installed or not in PATH" "Error"
        return $false
    }
}

function Test-Python {
    try {
        $pythonVersion = python --version
        Write-Status "Python: $pythonVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Python not available" "Error"
        return $false
    }
}

function Test-Git {
    try {
        $gitVersion = git --version
        Write-Status "Git: $gitVersion" "Success"
        return $true
    }
    catch {
        Write-Status "Git not installed or not in PATH" "Error"
        return $false
    }
}

function Test-DevelopmentServices {
    Write-Status "Testing development services..." "Info"
    
    try {
        # Check if containers are running
        $containers = docker ps --format "table {{.Names}}\t{{.Status}}" 2>$null
        if ($containers) {
            Write-Host "${BLUE}Running containers:${RESET}"
            $containers | ForEach-Object { Write-Host "  $_" }
            
            # Test MySQL
            $mysqlRunning = docker ps --filter "name=inswing-mysql" --filter "status=running" --format "{{.Names}}" 2>$null
            if ($mysqlRunning) {
                Write-Status "MySQL container is running" "Success"
            } else {
                Write-Status "MySQL container not found" "Warning"
            }
            
            # Test Redis
            $redisRunning = docker ps --filter "name=inswing-redis" --filter "status=running" --format "{{.Names}}" 2>$null
            if ($redisRunning) {
                Write-Status "Redis container is running" "Success"
            } else {
                Write-Status "Redis container not found" "Warning"
            }
        } else {
            Write-Status "No containers are running" "Warning"
        }
        
        return $true
    }
    catch {
        Write-Status "Error checking containers: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-PythonEnvironment {
    Write-Status "Testing Python environment..." "Info"
    
    try {
        # Check if virtual environment exists
        if (Test-Path "venv") {
            Write-Status "Python virtual environment found" "Success"
            
            # Test if we can activate it
            .\venv\Scripts\Activate 2>$null
            if ($?) {
                Write-Status "Virtual environment activated successfully" "Success"
                
                # Check Python packages
                $fastapiCheck = pip show fastapi 2>$null
                if ($fastapiCheck) {
                    Write-Status "FastAPI is installed" "Success"
                } else {
                    Write-Status "FastAPI not found in virtual environment" "Warning"
                }
            } else {
                Write-Status "Could not activate virtual environment" "Warning"
            }
        } else {
            Write-Status "Python virtual environment not found" "Warning"
        }
        
        return $true
    }
    catch {
        Write-Status "Error testing Python environment: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-NetworkConnectivity {
    Write-Status "Testing network connectivity..." "Info"
    
    try {
        # Test MySQL connection
        $mysqlTest = docker exec inswing-mysql mysql -u inswing_user -pinswing_password123 -e "SELECT 1;" inswing 2>$null
        if ($mysqlTest) {
            Write-Status "MySQL connection test passed" "Success"
        } else {
            Write-Status "MySQL connection test failed" "Warning"
        }
        
        # Test Redis connection
        $redisTest = docker exec inswing-redis redis-cli -a redis_password123 ping 2>$null
        if ($redisTest -eq "PONG") {
            Write-Status "Redis connection test passed" "Success"
        } else {
            Write-Status "Redis connection test failed" "Warning"
        }
        
        return $true
    }
    catch {
        Write-Status "Network connectivity test error: $($_.Exception.Message)" "Warning"
        return $true  # Don't fail verification for connectivity tests
    }
}

function Show-EnvironmentStatus {
    Write-Host ""
    Write-Host "${GREEN}📊 inSwing Environment Status${RESET}"
    Write-Host "================================="
    Write-Host ""
    
    # Check core dependencies
    Write-Host "${BLUE}Core Dependencies:${RESET}"
    $dockerOK = Test-Docker
    $composeOK = Test-DockerCompose
    $flutterOK = Test-Flutter
    $pythonOK = Test-Python
    $gitOK = Test-Git
    
    Write-Host ""
    
    # Check development services
    Write-Host "${BLUE}Development Services:${RESET}"
    $servicesOK = Test-DevelopmentServices
    
    Write-Host ""
    
    # Check Python environment
    Write-Host "${BLUE}Python Environment:${RESET}"
    $pythonEnvOK = Test-PythonEnvironment
    
    Write-Host ""
    
    # Check network connectivity
    Write-Host "${BLUE}Network Connectivity:${RESET}"
    $networkOK = Test-NetworkConnectivity
    
    Write-Host ""
    
    # Overall status
    $allOK = $dockerOK -and $composeOK -and $flutterOK -and $pythonOK -and $gitOK
    
    if ($allOK) {
        Write-Status "Environment is ready for development! 🎉" "Success"
    } else {
        Write-Status "Some issues detected. Please check the warnings above." "Warning"
    }
    
    Write-Host ""
    Write-Host "${BLUE}Quick Commands:${RESET}"
    Write-Host "  • Start services: docker-compose up -d"
    Write-Host "  • Stop services: docker-compose down"
    Write-Host "  • View logs: docker-compose logs -f"
    Write-Host "  • Activate Python: .\venv\Scripts\Activate"
    Write-Host ""
}

# Run verification
Show-EnvironmentStatus