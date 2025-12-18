Function Revoke-OAIProjectAccess {
    <#
        .SYNOPSIS
        Revokes shared access to a project from the OpenAI Compliance API.

        .DESCRIPTION
        Removes access to a project for all share recipients (users, groups, etc.) from the ChatGPT Enterprise workspace.
        The project is still available for use by the owner.

        .PARAMETER ProjectId
        The ID of the project to revoke access for.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Revoke-OAIProjectAccess -ProjectId "proj-123456789"

        .EXAMPLE
        Get-OAIProject -All | Revoke-OAIProjectAccess

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ProjectId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Project manager"
        $project_manager = [OAIProject]::new($script:client)

    } Process {
        ForEach ($id in $projectId) {
            Write-Debug "Revoking project access: $id"
            If ($PSCmdlet.ShouldProcess("Revoke access to project $id (remove all shared users)", "Revoke-OAIProjectAccess", "Revoke project access")) {
                Try {
                    $project_manager.IsolateProject($id)
                    Write-Debug "Project access revoked successfully"
                
                } Catch {
                    Write-Error "Error revoking project access: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            }
        }     
    } 
}