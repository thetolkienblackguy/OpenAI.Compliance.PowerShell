Function Initialize-OAICompliance {
    <#
        .SYNOPSIS
        Initializes the OpenAI Compliance API client.

        .DESCRIPTION
        Initializes the OpenAI Compliance API client for accessing ChatGPT Enterprise workspace compliance data.

        .PARAMETER WorkspaceId
        The workspace ID for the ChatGPT Enterprise workspace.

        .PARAMETER ApiKey
        The API key for the OpenAI Compliance API.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Void

        .EXAMPLE
        Initialize-OAICompliance -WorkspaceId "12345678-1234-1234-1234-123456789012" -ApiKey "sk-proj-..."

    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$WorkspaceId,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$ApiKey
    
    )
    Begin {
        Write-Debug "Initializing OpenAI Compliance API client"

    } Process {
        Try {
            $script:client = [OAIComplianceRequestClient]::new($workspaceId, $apiKey)
        
        } Catch {
            Write-Error "Failed to initialize OpenAI Compliance client: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    
    } End {
        Write-Host "Successfully initialized OpenAI Compliance client." -ForegroundColor Green
    
    }
}