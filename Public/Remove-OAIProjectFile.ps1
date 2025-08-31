Function Remove-OAIProjectFile {
    <#
        .SYNOPSIS
        Deletes a project file from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a file associated with a project from the ChatGPT Enterprise workspace. The file reference
        is also removed from all projects in the workspace.

        .PARAMETER ProjectId
        The ID of the project that owns the file.

        .PARAMETER FileId
        The ID of the file to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIProjectFile -ProjectId "proj-123" -FileId "file-456"

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ProjectId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$FileId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Project manager"
        $project_manager = [OAIProject]::new($script:client)

    } Process {
        ForEach ($project in $projectId) {
            ForEach ($file in $fileId) {
                Write-Debug "Deleting project file for ProjectId: $project, FileId: $file"
                Try {
                    If ($PSCmdlet.ShouldProcess("Delete project file $file for project $project", "Remove-OAIProjectFile", "Delete project file")) {
                        Try {
                            $response = $project_manager.DeleteProjectFile($project, $file)
                            Write-Debug "Project file deleted successfully"
                            $response
                        
                        } Catch {
                            Write-Error "Error deleting project file: $($_.Exception.Message)" -ErrorAction Stop
                        
                        }
                    } Else {
                        Write-Debug "Skipping project file deletion due to ShouldProcess"
                    
                    }
                } Catch {
                    Write-Error "Error deleting project file: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            }
        }
    } End {
        Write-Debug "Successfully processed project file deletion"
    
    }
}