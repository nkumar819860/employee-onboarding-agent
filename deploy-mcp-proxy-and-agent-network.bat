@echo off
echo ===============================================
echo MCP Proxy and Agent Network Deployment Script
echo ===============================================

:: Set environment variables (Update these with your actual credentials)
set ANYPOINT_USERNAME=your-username
set ANYPOINT_PASSWORD=your-password
set ANYPOINT_CLIENT_ID=your-client-id
set ANYPOINT_CLIENT_SECRET=your-client-secret
set ANYPOINT_ENVIRONMENT=Sandbox
set ANYPOINT_BUSINESS_GROUP=your-business-group

echo.
echo Step 1: Deploying MCP Proxy to CloudHub...
echo ===========================================

cd mcp-servers\employee-onboarding-agent-mcp-proxy

echo Building and deploying MCP Proxy...
call mvn clean compile ^
    -Danypoint.username=%ANYPOINT_USERNAME% ^
    -Danypoint.password=%ANYPOINT_PASSWORD% ^
    -Danypoint.client_id=%ANYPOINT_CLIENT_ID% ^
    -Danypoint.client_secret=%ANYPOINT_CLIENT_SECRET% ^
    -Danypoint.environment=%ANYPOINT_ENVIRONMENT% ^
    -Danypoint.businessGroup=%ANYPOINT_BUSINESS_GROUP% ^
    mule:deploy

if %ERRORLEVEL% neq 0 (
    echo ERROR: MCP Proxy deployment failed!
    cd ..\..
    pause
    exit /b 1
)

echo MCP Proxy deployed successfully!

cd ..\..

echo.
echo Step 2: Deploying Agent Network...
echo ==================================

cd agent-network

echo Validating Agent Network configuration...
call validate-agent-network-config.bat

if %ERRORLEVEL% neq 0 (
    echo ERROR: Agent Network validation failed!
    cd ..
    pause
    exit /b 1
)

echo Agent Network configuration validated successfully!

echo.
echo Step 3: Verification...
echo ======================

echo Checking MCP Proxy deployment status...
timeout /t 30 /nobreak

:: Test MCP Proxy endpoint
echo Testing MCP Proxy endpoint...
curl -X GET "https://employee-onboarding-agent-mcp-proxy.us-e1.cloudhub.io/api/health" ^
     -H "Content-Type: application/json" ^
     -w "HTTP Status: %%{http_code}\n" ^
     -s -o nul

echo.
echo Testing Agent Broker integration...
curl -X GET "https://employee-onboarding-agent-broker.us-e1.cloudhub.io/api/health" ^
     -H "Content-Type: application/json" ^
     -w "HTTP Status: %%{http_code}\n" ^
     -s -o nul

echo.
echo ===============================================
echo Deployment Summary:
echo ===============================================
echo 1. MCP Proxy: https://employee-onboarding-agent-mcp-proxy.us-e1.cloudhub.io
echo 2. Agent Network: Configured and validated
echo 3. Integration: MCP Proxy -> Agent Broker
echo ===============================================

echo.
echo Deployment completed successfully!
echo Check CloudHub Runtime Manager for detailed status.

cd ..
pause
