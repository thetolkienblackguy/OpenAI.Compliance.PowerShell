Function Remove-OAIProject {
    <#
        .SYNOPSIS
        Deletes a project from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a project from the ChatGPT Enterprise workspace, including all associated files. 
        Does not delete conversations that used the project.

        .PARAMETER ProjectId
        The ID of the project to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIProject -ProjectId "proj-123456789"

        .EXAMPLE
        Get-OAIProject -All | Remove-OAIProject

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
            Write-Debug "Deleting project: $id"
            Try {
                If ($PSCmdlet.ShouldProcess("Delete project $id", "Remove-OAIProject", "Delete project")) {
                    Try {
                        $response = $project_manager.DeleteProject($id)
                        Write-Debug "Project deleted successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error deleting project: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping project deletion due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error deleting project: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }

    } End {
        Write-Debug "Successfully processed project deletion"
    
    }
}