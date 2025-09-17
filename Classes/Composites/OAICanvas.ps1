
class OAICanvas {
    [OAIComplianceRequestClient]$Client

    OAICanvas([OAIComplianceRequestClient]$client) {
        $this.Client = $client
    
    }

    #region Canvas Operations
    # Get all user canvases with optional top limit
    [object]GetUserCanvases([string]$userId, [int]$top = 0) {
        $segments = @("users", $userId, "canvases")
        return $this.Client.Paginate($segments, @{}, $top)
    
    }

    # Get canvas content
    [object]GetCanvasContent([string]$userId, [string]$textdocId) {
        $segments = @("users", $userId, "canvas", $textdocId)
        return $this.Client.InvokeGetRequest($segments, @{})
    
    }

    # Delete canvas text document
    [object]DeleteCanvas([string]$userId, [string]$textdocId) {
        $segments = @("users", $userId, "canvas", $textdocId)
        return $this.Client.InvokeDeleteRequest($segments, @{})
    
    }
    #endregion
}