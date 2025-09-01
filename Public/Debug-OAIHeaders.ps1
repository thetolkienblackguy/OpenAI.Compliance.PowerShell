Function Debug-OAIHeaders {
    <#
        .SYNOPSIS
        Displays the OpenAI Compliance client headers for debugging.

        .DESCRIPTION
        Shows the current headers being used by the OpenAI Compliance client with the API key masked for security.

        .INPUTS
        None
        
        .OUTPUTS
        System.String

        .EXAMPLE
        Debug-OAIHeaders
        Displays the current client headers.

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
        Write-Debug "Retrieving client headers for debugging"
        Try {
            $headers = $script:client.DebugHeaders()
            Write-Debug "Headers retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving client headers: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } End {
        Write-Debug "Successfully retrieved client headers"
        $headers
    
    }
}