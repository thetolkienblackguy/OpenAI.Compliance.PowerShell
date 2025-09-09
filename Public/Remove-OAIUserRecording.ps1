Function Remove-OAIUserRecording {
    <#
        .SYNOPSIS
        Deletes a user recording from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a specific recording for a user from the ChatGPT Enterprise workspace.

        .PARAMETER UserId
        The ID of the user who owns the recording.

        .PARAMETER RecordingId
        The ID of the recording to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIUserRecording -UserId "user-123" -RecordingId "recording-456"

        .EXAMPLE
        Get-OAIUserRecording -UserId "user-123" -All | Remove-OAIUserRecording

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
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
        ForEach ($user in $userId) {
            ForEach ($recording in $recordingId) {
                Write-Debug "Deleting user recording for UserId: $user, RecordingId: $recording"
                If ($PSCmdlet.ShouldProcess("Delete recording $recording for user $user", "Remove-OAIUserRecording", "Delete user recording")) {
                    Try {
                        $recording_manager.DeleteUserRecording($user, $recording)
                        Write-Debug "User recording deleted successfully"
                    
                    } Catch {
                        Write-Error "Error deleting user recording: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                }
            }
        }
    }
}