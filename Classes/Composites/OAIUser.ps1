class OAIUser {
    [OAIComplianceRequestClient]$Client

    OAIUser([OAIComplianceRequestClient]$client) {
        $this.Client = $client
    
    }

    #region User Operations
    # Get all workspace users with optional top limit
    [object]GetUsers([int]$top = 0) {
        return $this.Client.Paginate(@("users"), @{}, $top)
    
    }

    # Get user file content
    [object]GetUserFileContent([string]$userId, [string]$fileId) {
        $segments = @("users", $userId, "files", $fileId)
        return $this.Client.InvokeGetRequest($segments, @{})
    
    }

    # Delete user-owned file
    [object]DeleteUserFile([string]$userId, [string]$fileId) {
        $segments = @("users", $userId, "files", $fileId)
        return $this.Client.InvokeDeleteRequest($segments, @{})
    
    }

    # Delete user-owned file with conversation context (required for audio/video files)
    [object]DeleteUserFile([string]$userId, [string]$fileId, [string]$conversationId) {
        $segments = @("users", $userId, "files", $fileId)
        $query_params = @{}    
        $query_params["conversation_id"] = $conversationId
        return $this.Client.InvokeDeleteRequest($segments, $query_params)
    
    }
    #endregion
}