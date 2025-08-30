class OAICodex {
    [OAIComplianceRequestClient]$Client

    OAICodex([OAIComplianceRequestClient]$client) {
        $this.Client = $client

    }

    #region Codex Operations
    # Get all codex tasks with optional top limit
    [object]GetCodexTasks([int]$top = 0) {
        return $this.Client.Paginate(@("codex_tasks"), @{}, $top)

    }

    # Get specific codex task
    [object]GetCodexTask([string]$taskId) {
        $segments = @("codex_tasks", $taskId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete codex task
    [object]DeleteCodexTask([string]$taskId) {
        $segments = @("codex_tasks", $taskId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get all codex environments with optional top limit
    [object]GetCodexEnvironments([int]$top = 0) {
        return $this.Client.Paginate(@("codex_environments"), @{}, $top)

    }

    # Get specific codex environment
    [object]GetCodexEnvironment([string]$environmentId) {
        $segments = @("codex_environments", $environmentId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete codex environment
    [object]DeleteCodexEnvironment([string]$environmentId) {
        $segments = @("codex_environments", $environmentId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }
    #endregion
}