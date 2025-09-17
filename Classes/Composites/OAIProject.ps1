class OAIProject {
    [OAIComplianceRequestClient]$Client

    OAIProject([OAIComplianceRequestClient]$client) {
        $this.Client = $client

    }

    #region Project Operations
    # Get all workspace projects with optional top limit
    [object]GetProjects([int]$top = 0) {
        return $this.Client.Paginate(@("projects"), @{}, $top)

    }

    # Get specific project by ID
    [object]GetProject([string]$projectId) {
        $segments = @("projects", $projectId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete specific project
    [object]DeleteProject([string]$projectId) {
        $segments = @("projects", $projectId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get project configurations
    [object]GetProjectConfigurations([string]$projectId, [int]$top = 0) {
        $segments = @("projects", $projectId, "configs")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Get project shared users
    [object]GetProjectSharedUsers([string]$projectId, [int]$top = 0) {
        $segments = @("projects", $projectId, "shared_users")
        return $this.Client.Paginate($segments, @{}, $top)

    }

    # Isolate project (remove all shared users)
    [object]IsolateProject([string]$projectId) {
        $segments = @("projects", $projectId, "shared_users")
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }

    # Get project file content
    [object]GetProjectFileContent([string]$fileId) {
        $segments = @("project_files", $fileId)
        return $this.Client.InvokeGetRequest($segments, @{})

    }

    # Delete project file
    [object]DeleteProjectFile([string]$projectId, [string]$fileId) {
        $segments = @("projects", $projectId, "files", $fileId)
        return $this.Client.InvokeDeleteRequest($segments, @{})

    }
    #endregion
}