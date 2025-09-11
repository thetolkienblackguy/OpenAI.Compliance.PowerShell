Function Debug-OAIResponses {
    <#
        .SYNOPSIS
        Displays OpenAI Compliance API response history for debugging.

        .DESCRIPTION
        Shows the history of API responses made by the OpenAI Compliance client including pagination metadata,
        timestamps, and response details for troubleshooting API issues.

        .PARAMETER Last
        Number of recent responses to display. If not specified, returns all stored responses.

        .INPUTS
        System.Int32
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Debug-OAIResponses
        Displays all stored API response history.

        .EXAMPLE
        Debug-OAIResponses -Last 5
        Displays the last 5 API responses.

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateRange(1, 100)]
        [int]$Last
    )
    
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
    } Process {
        Write-Debug "Retrieving API response history for debugging"
        Try {
            If ($last) {
                $response_history = $script:client.GetLastResponses($last)
            
            } Else {
                $response_history = $script:client.DebugResponses()
            
            }
            Write-Debug "Response history retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving response history: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } End {
        Write-Debug "Successfully retrieved response history"
        $response_history
    
    }
}