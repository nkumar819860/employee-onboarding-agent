@echo off
echo =================================================================
echo ASSET ALLOCATION FIX VALIDATION TEST
echo =================================================================
echo.
echo Testing the assets allocation fix for "payload.assets" null issue
echo.

set TEST_PAYLOAD={"employeeId": "EMP001", "firstName": "John", "lastName": "Smith", "email": "john.smith@company.com", "department": "IT", "position": "Developer", "assets": ["LAPTOP", "ID_CARD", "MOBILE_PHONE"]}

echo Testing Assets Allocation Endpoint directly...
echo.
echo Payload being sent:
echo %TEST_PAYLOAD%
echo.

REM Test local endpoint first
echo =================================================================
echo TESTING LOCAL ENDPOINT (if running locally)
echo =================================================================
curl -X POST ^
  "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "%TEST_PAYLOAD%" ^
  --connect-timeout 10 ^
  --max-time 30 ^
  -w "\nStatus: %%{http_code}\nTime: %%{time_total}s\n" ^
  2>nul

if %ERRORLEVEL% NEQ 0 (
    echo Local endpoint not available or not responding
    echo.
)

echo.
echo =================================================================
echo TESTING CLOUDHUB ENDPOINT (if deployed)
echo =================================================================

REM Try CloudHub endpoint with parameterized URL
curl -X POST ^
  "https://{{asset_allocation_url}}/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "%TEST_PAYLOAD%" ^
  --connect-timeout 10 ^
  --max-time 30 ^
  -w "\nStatus: %%{http_code}\nTime: %%{time_total}s\n" ^
  2>nul

if %ERRORLEVEL% NEQ 0 (
    echo CloudHub endpoint not available or not responding
    echo Note: Replace {{asset_allocation_url}} with your actual deployment URL
    echo.
)

echo.
echo =================================================================
echo TEST VARIATIONS
echo =================================================================

echo Testing with empty assets array...
set EMPTY_ASSETS_PAYLOAD={"employeeId": "EMP001", "firstName": "John", "lastName": "Smith", "email": "john.smith@company.com", "department": "IT", "position": "Developer", "assets": []}

curl -X POST ^
  "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "%EMPTY_ASSETS_PAYLOAD%" ^
  --connect-timeout 10 ^
  --max-time 30 ^
  -w "\nStatus: %%{http_code}\nTime: %%{time_total}s\n" ^
  2>nul

echo.
echo Testing with single asset...
set SINGLE_ASSET_PAYLOAD={"employeeId": "EMP001", "firstName": "John", "lastName": "Smith", "email": "john.smith@company.com", "department": "IT", "position": "Developer", "assets": ["LAPTOP"]}

curl -X POST ^
  "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "%SINGLE_ASSET_PAYLOAD%" ^
  --connect-timeout 10 ^
  --max-time 30 ^
  -w "\nStatus: %%{http_code}\nTime: %%{time_total}s\n" ^
  2>nul

echo.
echo =================================================================
echo HEALTH CHECK
echo =================================================================
echo Testing health endpoint to ensure service is running...

curl -X GET ^
  "http://localhost:8081/api/health" ^
  -H "Accept: application/json" ^
  --connect-timeout 5 ^
  --max-time 15 ^
  -w "\nStatus: %%{http_code}\nTime: %%{time_total}s\n" ^
  2>nul

echo.
echo =================================================================
echo TEST SUMMARY
echo =================================================================
echo If you see successful responses (200 status codes) with allocated
echo assets in the response, then the fix is working correctly.
echo.
echo The fix changes:
echo   FROM: foreach collection="#[payload.assets]"
echo   TO:   foreach collection="#[vars.requestPayload.assets]"
echo.
echo This prevents the "Expecting Array or Object but got Null" error
echo that was occurring because payload.assets was null after the 
echo DataWeave transformation.
echo.

pause
