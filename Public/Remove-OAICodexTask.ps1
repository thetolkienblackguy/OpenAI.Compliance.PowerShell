Function Remove-OAICodexTask {
    <#
        .SYNOPSIS
        Deletes a codex task from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a codex task from the ChatGPT Enterprise workspace. This also deletes
        any associated execution artifacts.

        .PARAMETER TaskId
        The ID of the task to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAICodexTask -TaskId "task-123"

        .EXAMPLE
        Get-OAICodexTask -All | Remove-OAICodexTask

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$TaskId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Codex manager"
        $codex_manager = [OAICodex]::new($script:client)

    } Process {
        ForEach ($task in $taskId) {
            Write-Debug "Deleting codex task for TaskId: $task"
            Try {
                If ($PSCmdlet.ShouldProcess("Delete codex task $task", "Remove-OAICodexTask", "Delete codex task")) {
                    Try {
                        $response = $codex_manager.DeleteCodexTask($task)
                        Write-Debug "Codex task deleted successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error deleting codex task: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping codex task deletion due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error deleting codex task: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }

    } End {
        Write-Debug "Successfully processed codex task deletion"
    
    }
}