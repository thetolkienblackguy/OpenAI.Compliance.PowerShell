@{
    # Module metadata
    ModuleVersion       = "0.0.1"
    GUID                = "1a4496ad-a154-49a7-b1c0-961fa131483f"
    Author              = "Gabriel Delaney - gdelaney@phzconsulting.com | https://github.com/thetolkienblackguy"
    CompanyName         = "Phoenix Horizons LLC"
    Copyright           = "(c) Phoenix Horizons LLC. All rights reserved."
    Description         = "PowerShell module for the OpenAI Compliance API."

    # Supported PowerShell editions
    PowerShellVersion   = "5.1"
    CompatiblePSEditions = @("Desktop", "Core")

    # Dependencies
    RequiredModules     = @()

    # Module file paths
    RootModule          = "OpenAI.Compliance.PowerShell.psm1"

    # Functions to export
    FunctionsToExport   = @("*")
    CmdletsToExport     = @()
    VariablesToExport   = @()
    AliasesToExport     = @()

    # Private Data
    PrivateData = @{
        PSData = @{
            Tags         = @("OpenAI", "ChatGPT", "Compliance", "PowerShell", "API", "REST")
            ReleaseNotes = "v0.0.1 - Initial module creation."
        }
    }
}



