class OAIAutomation {
    [OAIComplianceRequestClient]$Client

    OAIAutomation([OAIComplianceRequestClient]$client) {
        $this.Client = $client

    }

    #region Automation Operations
    # Get user automations with optional top limit
    [object]GetUserAutomations([string]$userId, [int]$top = 0) {
        $segments = @("users", $userId, "automations")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Get user automations since timestamp
    [object]GetUserAutomationsSince([string]$userId, $sinceTimestamp, [int]$top = 0) {
        $unix_timestamp = [OAIComplianceRequestClient]::ConvertToUnixTimestamp($sinceTimestamp)
        $query_params = @{}
        $query_params["since_timestamp"] = $unix_timestamp
        $segments = @("users", $userId, "automations")
        return $this.Client.Paginate($segments, $query_params, $top)

    }

    # Delete user automation
    [object]DeleteUserAutomation([string]$userId, [string]$automationId) {
        $segments = @("users", $userId, "automations", $automationId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }
    #endregion
}