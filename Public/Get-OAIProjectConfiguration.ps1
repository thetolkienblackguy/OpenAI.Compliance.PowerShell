Function Get-OAIProjectConfiguration {
    <#
        .SYNOPSIS
        Retrieves project configurations from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves all configuration versions for a specific project from the ChatGPT Enterprise compliance API.

        .PARAMETER ProjectId
        The ID of the project whose configurations to retrieve.

        .PARAMETER Top
        Limits the number of configurations to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIProjectConfiguration -ProjectId "proj-123456789"

        .EXAMPLE
        Get-OAIProjectConfiguration -ProjectId "proj-123456789" -Top 10

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ProjectId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(0, 100)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Project manager"
        $project_manager = [OAIProject]::new($script:client)

    } Process {
        Write-Debug "Retrieving project configurations for ProjectId: $projectId"
        Try {
            If (!$top) {
                $top = 0
            
            }
            $project_manager.GetProjectConfigurations($projectId, $top)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving project configurations: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}