Function Remove-OAIRecording {
    <#
        .SYNOPSIS
        Deletes a recording from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a recording from the ChatGPT Enterprise workspace.

        .PARAMETER RecordingId
        The ID of the recording to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIRecording -RecordingId "recording-123"

        .EXAMPLE
        Get-OAIRecording -All | Remove-OAIRecording

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$RecordingId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Recording manager"
        $recording_manager = [OAIRecording]::new($script:client)

    } Process {
        ForEach ($recording in $recordingId) {
            Write-Debug "Deleting recording for RecordingId: $recording"
            Try {
                If ($PSCmdlet.ShouldProcess("Delete recording $recording", "Remove-OAIRecording", "Delete recording")) {
                    Try {
                        $response = $recording_manager.DeleteRecording($recording)
                        Write-Debug "Recording deleted successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error deleting recording: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping recording deletion due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error deleting recording: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }

    } End {
        Write-Debug "Successfully processed recording deletion"
    
    }
}