# load-env.ps1 - Load environment variables from .env file
# Usage: . .\scripts\load-env.ps1

$ScriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvFile = Join-Path $ScriptDir ".env"

if (-not (Test-Path $EnvFile)) {
  Write-Error ".env file not found at $EnvFile"
  Write-Host "Please copy .env.example to .env and fill in your values:"
  Write-Host "  Copy-Item .env.example .env"
  Write-Host "  notepad .env  # or your preferred editor"
  exit 1
}

# Load all variables from .env file
Get-Content $EnvFile | Where-Object { $_ -and -not $_.StartsWith('#') } | ForEach-Object {
  $parts = $_ -split '=', 2
  if ($parts.Count -eq 2) {
    $key = $parts[0].Trim().Replace('export ', '')
    $value = $parts[1].Trim() -replace '^"(.*)"$', '$1'
    [Environment]::SetEnvironmentVariable($key, $value)
    Set-Item -Path "env:$key" -Value $value
  }
}

# Validate required variables
$RequiredVars = @(
  "TF_VAR_subscription_id",
  "ARM_CLIENT_ID",
  "ARM_TENANT_ID",
  "ARM_SUBSCRIPTION_ID"
)

$MissingVars = @()
foreach ($var in $RequiredVars) {
  if (-not (Get-Item -Path "env:$var" -ErrorAction SilentlyContinue)) {
    $MissingVars += $var
  }
}

if ($MissingVars.Count -gt 0) {
  Write-Error "Missing required environment variables:"
  foreach ($var in $MissingVars) {
    Write-Host "  - $var"
  }
  Write-Host "Please update your .env file with the missing values."
  exit 1
}

Write-Host "✓ Environment variables loaded successfully"
$SubId = $env:TF_VAR_subscription_id.Substring(0, 8)
$ClientId = $env:ARM_CLIENT_ID.Substring(0, 8)
$TenantId = $env:ARM_TENANT_ID.Substring(0, 8)
Write-Host "  Subscription ID: ${SubId}..."
Write-Host "  Client ID: ${ClientId}..."
Write-Host "  Tenant ID: ${TenantId}..."
