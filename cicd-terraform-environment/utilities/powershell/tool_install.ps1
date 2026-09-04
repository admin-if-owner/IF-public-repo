# Fetch the latest WinGet download URL from GitHub API
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL -UseBasicParsing).Content | ConvertFrom-Json | Select-Object -ExpandProperty "assets" | Where-Object "browser_download_url" -Match '\.msixbundle' | Select-Object -ExpandProperty "browser_download_url"

# Download the installer bundle
Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

# Install it using Appx packages
Add-AppxPackage -Path "Setup.msix"

# Clean up installer file
Remove-Item "Setup.msix"


winget install -e --id Microsoft.AzureCLI
winget install -e --id HashiCorp.Terraform