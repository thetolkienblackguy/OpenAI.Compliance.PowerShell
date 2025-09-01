Function Debug-OAIRequest {
    <#
        .SYNOPSIS
        Displays the last OpenAI Compliance API request for debugging.

        .DESCRIPTION
        Shows the details of the last API request made by the OpenAI Compliance client with the API key masked for security.

        .INPUTS
        None
        
        .OUTPUTS
        System.String

        .EXAMPLE
        Debug-OAIRequest
        Displays the last API request details.

    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param()
    
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
    } Process {
        Write-Debug "Retrieving last request details for debugging"
        Try {
            $request_details = $script:client.DebugRequest()
            Write-Debug "Request details retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving request details: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } End {
        Write-Debug "Successfully retrieved request details"
        $request_details
    
    }
}