Function Get-OAIUserRecordingTranscript {
    <#
        .SYNOPSIS
        Retrieves user recording transcript from the OpenAI Compliance API.

        .DESCRIPTION
        Downloads the transcript for a user's recording from the ChatGPT Enterprise compliance API.
        Can optionally include a summary of the recording.

        .PARAMETER UserId
        The ID of the user who created the recording.

        .PARAMETER RecordingId
        The ID of the recording to get the transcript for.

        .PARAMETER IncludeSummary
        Whether to include a summary with the transcript.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAIUserRecordingTranscript -UserId "user-123" -RecordingId "recording-456"
        Gets the transcript for the specified recording.

        .EXAMPLE
        Get-OAIUserRecordingTranscript -UserId "user-123" -RecordingId "recording-456" -IncludeSummary
        Gets the transcript and summary for the specified recording.

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [string]$RecordingId,
        [Parameter(Mandatory=$false, Position=2)]
        [switch]$IncludeSummary
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Recording manager"
        $recording_manager = [OAIRecording]::new($script:client)

    } Process {
        Write-Debug "Retrieving user recording transcript for UserId: $userId, RecordingId: $recordingId, IncludeSummary: $($includeSummary.IsPresent)"
        Try {
            $response = $recording_manager.GetUserRecordingTranscript($userId, $recordingId, $includeSummary.IsPresent)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving user recording transcript: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } End {
        Write-Debug "Successfully retrieved user recording transcript"
        $response
    
    }
}