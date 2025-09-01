class OAIConversation {
    [OAIComplianceRequestClient]$Client

    OAIConversation([OAIComplianceRequestClient]$client) {
        $this.Client = $client
    
    }

    #region Conversation Operations
    # Get all workspace conversations with optional top limit
    [object]GetConversations([int]$top = 0) {
        return $this.GetConversationsSince(0, $top)
    
    }

    # Get conversations since a specific timestamp with optional top limit
    [object]GetConversationsSince($sinceTimestamp, [int]$top = 0) {
        $unix_timestamp = [OAIComplianceRequestClient]::ConvertToUnixTimestamp($sinceTimestamp)
        $query_params = @{}
        $query_params["since_timestamp"] = $unix_timestamp
        return $this.Client.Paginate(@("conversations"), $query_params, $top)
    
    }

    # Delete a specific conversation
    [object]DeleteConversation([string]$conversationId) {
        $segments = @("conversations", $conversationId)
        return $this.Client.InvokeDeleteRequest($segments, @{})
    
    }
    #endregion
}