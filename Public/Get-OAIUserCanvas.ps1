Function Get-OAIUserCanvas {
    <#
        .SYNOPSIS
        Retrieves user canvases from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves canvases for a specific user from the ChatGPT Enterprise compliance API.

        .PARAMETER UserId
        The ID of the user whose canvases to retrieve.

        .PARAMETER Top
        Limits the number of canvases to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUserCanvas -UserId "user-123"

        .EXAMPLE
        Get-OAIUserCanvas -UserId "user-123" -Top 50

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("Id")]
        [string[]]$UserId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(0, 100)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Canvas manager"
        $canvas_manager = [OAICanvas]::new($script:client)

    } Process {
        If (!$top) {
            $top = 0
        
        } 
        ForEach ($id in $userId) {
            Try {
                Write-Debug "Retrieving user canvases for UserId: $id"
                $canvas_manager.GetUserCanvases($id, $top)
        
            } Catch {
                Write-Error "Error retrieving user canvases: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
        Write-Debug "Response retrieved successfully"

    } 
}