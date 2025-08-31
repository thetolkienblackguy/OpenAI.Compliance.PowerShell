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
            Try {
                If ($PSCmdlet.ShouldProcess("Revoke access to project $id (remove all shared users)", "Revoke-OAIProjectAccess", "Revoke project access")) {
                    Try {
                        $response = $project_manager.IsolateProject($id)
                        Write-Debug "Project access revoked successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error revoking project access: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping project access revocation due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error revoking project access: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
    } End {
        Write-Debug "Successfully processed project access revocation"
    
    }
}