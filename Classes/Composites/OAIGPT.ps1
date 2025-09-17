class OAIGPT {
    [OAIComplianceRequestClient]$Client

    OAIGPT([OAIComplianceRequestClient]$client) {
        $this.Client = $client
    }

    #region GPT Operations
    # Get all workspace GPTs with optional top limit
    [object]GetGPTs([int]$top = 0) {
        return $this.Client.Paginate(@("gpts"), @{}, $top)

    }

    # Get specific GPT by ID
    [object]GetGPT([string]$gptId) {
        $segments = @("gpts", $gptId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete specific GPT
    [object]DeleteGPT([string]$gptId) {
        $segments = @("gpts", $gptId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get GPT configurations
    [object]GetGPTConfigurations([string]$gptId, [int]$top = 0) {
        $segments = @("gpts", $gptId, "configs")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Get GPT shared users
    [object]GetGPTSharedUsers([string]$gptId, [int]$top = 0) {
        $segments = @("gpts", $gptId, "shared_users")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Isolate GPT (remove all shared users)
    [object]IsolateGPT([string]$gptId) {
        $segments = @("gpts", $gptId, "shared_users")
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get GPT file content
    [object]GetGPTFileContent([string]$fileId) {
        $segments = @("gpt_files", $fileId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete GPT file
    [object]DeleteGPTFile([string]$gptId, [string]$fileId) {
        $segments = @("gpts", $gptId, "files", $fileId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }
    #endregion
}