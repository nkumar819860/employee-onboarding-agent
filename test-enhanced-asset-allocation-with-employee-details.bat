@echo off
echo ========================================
echo Testing Enhanced Asset Allocation with Employee Details
echo ========================================
echo.

echo Testing asset allocation with comprehensive employee verification...

curl -X POST "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -H "X-MCP-Client: test-client" ^
  -d "{\"employeeId\": \"EMP001\", \"firstName\": \"John\", \"lastName\": \"Smith\", \"email\": \"john.smith@company.com\", \"department\": \"Engineering\", \"position\": \"Senior Developer\", \"manager\": \"Sarah Johnson\", \"managerEmail\": \"sarah.johnson@company.com\", \"companyName\": \"TechCorp\", \"assets\": [\"LAPTOP\", \"ID_CARD\"]}" ^
  --max-time 30

echo.
echo ========================================
echo Test completed! 
echo.
echo The response should now include:
echo ✅ Comprehensive employee information with verification status
echo ✅ Enhanced allocation records with employee context
echo ✅ Detailed audit trail and integration information
echo ✅ Asset category breakdown and summary
echo ✅ Employee verification source tracking
echo ========================================
