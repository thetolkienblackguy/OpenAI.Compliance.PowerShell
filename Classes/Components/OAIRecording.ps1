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
    #endregion
}