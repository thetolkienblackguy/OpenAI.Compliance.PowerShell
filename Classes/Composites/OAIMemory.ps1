class OAIMemory {
    [OAIComplianceRequestClient]$Client

    OAIMemory([OAIComplianceRequestClient]$client) {
        $this.Client = $client

    }

    #region Memory Operations
    # Get all workspace memories with optional top limit
    [object]GetMemories([int]$top = 0) {
        return $this.Client.Paginate(@("memories"), @{}, $top)

    }

    # Get user memories with optional top limit
    [object]GetUserMemories([string]$userId, [int]$top = 0) {
        $segments = @("users", $userId, "memories")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Get user memories since timestamp
    [object]GetUserMemoriesSince([string]$userId, $sinceTimestamp, [int]$top = 0) {
        $unix_timestamp = [OAIComplianceRequestClient]::ConvertToUnixTimestamp($sinceTimestamp)
        $query_params = @{}
        $query_params["since_timestamp"] = $unix_timestamp
        $segments = @("users", $userId, "memories")
        return $this.Client.Paginate($segments, $query_params, $top)

    }

    # Delete specific memory entry
    [object]DeleteMemoryEntry([string]$userId, [string]$memoryContextId, [string]$memoryId) {
        $segments = @("users", $userId, "memory_contexts", $memoryContextId, "memories", $memoryId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }
    #endregion
}