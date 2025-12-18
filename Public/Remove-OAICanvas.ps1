Function Remove-OAICanvas {
    <#
        .SYNOPSIS
        Deletes a canvas from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a canvas text document for a user from the ChatGPT Enterprise workspace.

        .PARAMETER UserId
        The ID of the user who owns the canvas.

        .PARAMETER TextdocId
        The ID of the canvas text document to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAICanvas -UserId "user-123" -TextdocId "textdoc-456"

        .EXAMPLE
        Get-OAIUserCanvas -UserId "user-123" | Remove-OAICanvas

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
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
        ForEach ($user in $userId) {
            ForEach ($textdoc in $textdocId) {
                Write-Debug "Deleting canvas for UserId: $user, TextdocId: $textdoc"
                If ($PSCmdlet.ShouldProcess("Delete canvas $textdoc for user $user", "Remove-OAICanvas", "Delete canvas")) {
                    Try {
                        $canvas_manager.DeleteCanvas($user, $textdoc)
                        Write-Debug "Canvas deleted successfully"
                    
                    } Catch {
                        Write-Error "Error deleting canvas: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                }
            }
        }
    } 
}