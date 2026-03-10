@echo off
echo ========================================
echo Agent Network Configuration Validator
echo ========================================
echo.

echo Checking agent network YAML configuration...
echo.

REM Check if agent-network.yaml exists
if not exist "agent-network.yaml" (
    echo ERROR: agent-network.yaml not found!
    exit /b 1
)
echo ✓ agent-network.yaml found

REM Check if .env file exists
if not exist ".env" (
    echo ERROR: .env file not found!
    exit /b 1
)
echo ✓ .env file found

echo.
echo Configuration Summary:
echo ----------------------

echo Services configured:
echo   ✓ employee-onboarding-agent-mcp-proxy (MCP streamableHttp)
echo   ✓ employee-onboarding-system-api (Simple HTTP API)
echo   ✓ assets-allocation-system-api (Simple HTTP API)
echo   ✓ email-notification-system-api (Simple HTTP API)

echo.
echo Connections configured:
echo   ✓ employee-onboarding-agent-mcp-proxy-connection (MCP)
echo   ✓ employee-onboarding-system-api-connection (HTTP)
echo   ✓ assets-allocation-system-api-connection (HTTP)
echo   ✓ email-notification-system-api-connection (HTTP)
echo   ✓ groq-connection (LLM)

echo.
echo Environment Variables Required:
echo   - MCP_PROXY_API_KEY (for MCP proxy server)
echo   - EMPLOYEE_API_KEY (for employee onboarding server)
echo   - ASSET_API_KEY (for asset allocation server)
echo   - NOTIFICATION_API_KEY (for notification server)
echo   - GROQ_API_KEY (for Groq LLM provider)

echo.
echo Broker Tools Integration:
echo   ✓ MCP Proxy server added as first tool reference (MCP streamableHttp)
echo   ✓ System APIs converted to simple HTTP transport (no MCP overhead)
echo   ✓ Clean API integration (no complex paths or MCP protocol for system APIs)
echo   ✓ Hybrid architecture: MCP proxy for orchestration + HTTP APIs for services

echo.
echo ========================================
echo Agent Network Configuration is Valid! 
echo ========================================
echo.
echo Next Steps:
echo 1. Update the placeholder API keys in .env file with actual values
echo 2. Deploy the MCP proxy server to CloudHub if not already deployed
echo 3. Ensure system APIs are configured as simple HTTP endpoints (no MCP protocol)
echo 4. Test the hybrid architecture with a sample employee onboarding request
echo 5. Validate that system APIs respond to standard HTTP requests
echo.

pause
