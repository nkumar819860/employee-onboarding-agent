@echo off
echo ================================================================
echo Testing Idempotent Database Initialization Scripts
echo ================================================================

echo.
echo Testing Assets Allocation System API Database Initialization...
echo ----------------------------------------------------------------

REM Start the assets allocation system to test database initialization
echo Starting Assets Allocation System API...
cd mcp-servers\assets-allocation-system-api
start "Assets-Allocation-API" cmd /c "mvn clean compile mule:run -Dmule.env=local"

echo Waiting 30 seconds for startup...
timeout /t 30 > nul

echo Testing if service is running...
curl -s http://localhost:8082/api/health > nul
if %errorlevel% == 0 (
    echo ✓ Assets Allocation API started successfully
) else (
    echo ✗ Assets Allocation API failed to start
)

echo.
echo Stopping Assets Allocation API...
taskkill /f /im java.exe 2>nul

echo.
echo Testing Employee Onboarding System API Database Initialization...
echo ----------------------------------------------------------------

REM Start the employee onboarding system to test database initialization
echo Starting Employee Onboarding System API...
cd ..\employee-onboarding-system-api
start "Employee-Onboarding-API" cmd /c "mvn clean compile mule:run -Dmule.env=local"

echo Waiting 30 seconds for startup...
timeout /t 30 > nul

echo Testing if service is running...
curl -s http://localhost:8081/api/health > nul
if %errorlevel% == 0 (
    echo ✓ Employee Onboarding API started successfully
) else (
    echo ✗ Employee Onboarding API failed to start
)

echo.
echo Stopping Employee Onboarding API...
taskkill /f /im java.exe 2>nul

cd ..\..

echo.
echo ================================================================
echo Database Initialization Test Complete
echo ================================================================

pause
