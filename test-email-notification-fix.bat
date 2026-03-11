@echo off
echo Testing Email Notification 400 Error Fix...
echo.

REM Test the email notification endpoint directly first
echo Testing email notification API directly...
curl -X POST "https://email-notification-system-api.us-e1.cloudhub.io:443/api/send-welcome-email" ^
  -H "Content-Type: application/json" ^
  -d "{\"firstName\":\"John\",\"lastName\":\"Doe\",\"email\":\"john.doe@example.com\",\"employeeId\":\"EMP123\"}"
echo.

REM Now test the full orchestration
echo Testing full employee onboarding orchestration...
curl -X POST "https://employee-onboarding-agent-broker.us-e1.cloudhub.io:443/api/orchestrate-employee-onboarding" ^
  -H "Content-Type: application/json" ^
  -d "{\"firstName\":\"Jane\",\"lastName\":\"Smith\",\"email\":\"jane.smith@example.com\",\"department\":\"IT\",\"position\":\"Developer\",\"startDate\":\"2026-03-15\",\"assets\":[\"laptop\",\"phone\"]}"
echo.

echo Test completed.
pause
