class OAIRecording {
    [OAIComplianceRequestClient]$Client

    OAIRecording([OAIComplianceRequestClient]$client) {
        $this.Client = $client

    }

    #region Recording Operations
    # Get all recordings with optional top limit
    [object]GetRecordings([int]$top = 0) {
        return $this.Client.Paginate(@("recordings"), @{}, $top)

    }

    # Get specific recording
    [object]GetRecording([string]$recordingId) {
        $segments = @("recordings", $recordingId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete recording
    [object]DeleteRecording([string]$recordingId) {
        $segments = @("recordings", $recordingId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get user recordings with optional top limit
    [object]GetUserRecordings([string]$userId, [int]$top = 0) {
        $segments = @("users", $userId, "recordings")
        return $this.Client.Paginate($segments, @{}, $top)
    
    }

    # Get user recording transcript with optional summary
    [object]GetUserRecordingTranscript([string]$userId, [string]$recordingId, [bool]$includeSummary = $false) {
        $segments = @("users", $userId, "recordings", $recordingId, "transcript")
        $query_params = @{}
        If ($includeSummary) {
            $query_params["include_summary"] = "true"
        
        }
        return $this.Client.InvokeGetRequest($segments, $query_params)
    
    }

    # Delete user recording
    [object]DeleteUserRecording([string]$userId, [string]$recordingId) {
        $segments = @("users", $userId, "recordings", $recordingId)
        return $this.Client.InvokeDeleteRequest($segments, @{})
    
    }
    
    #endregion
}