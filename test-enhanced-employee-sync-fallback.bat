@echo off
echo ================================================================
echo Testing Enhanced Employee Sync Table First, API Fallback System
echo ================================================================
echo.

REM Test 1: Employee exists in sync table
echo Test 1: Testing employee that should exist in sync table (EMP001)
echo ----------------------------------------------------------------
curl -X POST "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -d "{\"employeeId\": \"EMP001\", \"assets\": [\"laptop\", \"id-card\"]}" ^
  | jq "."
echo.
echo.

REM Test 2: Employee not in sync table, should call API
echo Test 2: Testing new employee not in sync table (EMP999)
echo ----------------------------------------------------------------
curl -X POST "http://localhost:8081/api/allocate-assets" ^
  -H "Content-Type: application/json" ^
  -d "{\"employeeId\": \"EMP999\", \"firstName\": \"Test\", \"lastName\": \"Employee\", \"email\": \"test.employee@company.com\", \"assets\": [\"laptop\"]}" ^
  | jq "."
echo.
echo.

REM Test 3: Check health to ensure system is running
echo Test 3: Checking system health
echo ----------------------------------------------------------------
curl -X GET "http://localhost:8081/api/health" | jq "."
echo.
echo.

REM Test 4: List available assets
echo Test 4: Checking available assets after allocation
echo ----------------------------------------------------------------
curl -X GET "http://localhost:8081/api/get-available-assets" | jq "."
echo.
echo.

echo ================================================================
echo Enhanced Employee Sync Fallback Test Complete
echo ================================================================
echo.
echo Key Features Tested:
echo 1. Employee sync table lookup (local cache)
echo 2. API fallback when employee not in sync table
echo 3. Automatic employee synchronization to local table
echo 4. Fallback employee record creation
echo 5. Enhanced logging and source tracking
echo.
echo Check the logs to see the fallback behavior in action!
