Function Get-OAIProjectSharedUser {
    <#
        .SYNOPSIS
        Retrieves project shared users from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves users who have been granted access to a specific project from the ChatGPT Enterprise compliance API.

        .PARAMETER ProjectId
        The ID of the project whose shared users to retrieve.

        .PARAMETER Top
        Limits the number of shared users to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIProjectSharedUser -ProjectId "proj-123456789"

        .EXAMPLE
        Get-OAIProjectSharedUser -ProjectId "proj-123456789" -Top 50

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ProjectId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(1, [int]::MaxValue)]
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
        Write-Debug "Retrieving project shared users for ProjectId: $projectId"
        Try {
            If ($top) {
                $response = $project_manager.GetProjectSharedUsers($projectId, $top)
            
            } Else {
                $response = $project_manager.GetProjectSharedUsers($projectId, $null)
            
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving project shared users: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved project shared users"
        $response
    
    }
}