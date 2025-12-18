Function Get-OAICodexEnvironment {
    <#
        .SYNOPSIS
        Retrieves codex environments from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves codex environments from the ChatGPT Enterprise compliance API. Can retrieve all environments,
        limit the number of results returned, or get a specific environment by ID.

        .PARAMETER All
        Retrieves all workspace codex environments.

        .PARAMETER Top
        Limits the number of environments to retrieve.

        .PARAMETER EnvironmentId
        Retrieves a specific environment by ID.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAICodexEnvironment -All
        Retrieves all workspace codex environments.

        .EXAMPLE
        Get-OAICodexEnvironment -Top 10
        Retrieves the first 10 workspace codex environments.

        .EXAMPLE
        Get-OAICodexEnvironment -EnvironmentId "env-123"
        Retrieves a specific environment by ID.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top,
        [Parameter(
            Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ById"
            
        )]
        [Alias("Id")]
        [string]$EnvironmentId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Codex manager"
        $codex_manager = [OAICodex]::new($script:client)

    } Process {
        Write-Debug "Retrieving codex environments with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $codex_manager.GetCodexEnvironments($null)

                } "Top" {
                    $codex_manager.GetCodexEnvironments($top)

                } "ById" {
                    $codex_manager.GetCodexEnvironment($environmentId)

                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving codex environments: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}