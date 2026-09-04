terraform {
  backend "azurerm" {
    #values supplied at intilize time via -backend-config flags
    #locally: from .evn file via the load-env script
    # CI/CD: from github secrets workflow
    use_oidc = true
  }
}
