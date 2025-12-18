Function Get-OAICanvasContent {
    <#
        .SYNOPSIS
        Retrieves canvas content from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves the content of a specific canvas document for a user from the ChatGPT Enterprise compliance API.

        .PARAMETER UserId
        The ID of the user who owns the canvas.

        .PARAMETER TextdocId
        The ID of the canvas text document to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAICanvasContent -UserId "user-123" -TextdocId "textdoc-456"

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("Id")]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$TextdocId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Canvas manager"
        $canvas_manager = [OAICanvas]::new($script:client)

    } Process {
        Write-Debug "Retrieving canvas content for UserId: $userId, TextdocId: $textdocId"
        Try {
            $canvas_manager.GetCanvasContent($userId, $textdocId)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving canvas content: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}