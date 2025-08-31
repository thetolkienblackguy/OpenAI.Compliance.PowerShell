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
        [Parameter(Mandatory=$true, Position=0)]
        [string]$UserId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(1, [int]::MaxValue)]
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
        Write-Debug "Retrieving user canvases for UserId: $userId"
        Try {
            If ($top) {
                $response = $canvas_manager.GetUserCanvases($userId, $top)
            
            } Else {
                $response = $canvas_manager.GetUserCanvases($userId, $null)
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving user canvases: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } End {
        Write-Debug "Successfully retrieved user canvases"
        $response
    
    }
}