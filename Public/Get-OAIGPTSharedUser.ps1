Function Get-OAIGPTSharedUser {
    <#
        .SYNOPSIS
        Retrieves GPT shared users from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves users who have been granted access to a specific GPT from the ChatGPT Enterprise compliance API.

        .PARAMETER GPTId
        The ID of the GPT whose shared users to retrieve.

        .PARAMETER Top
        Limits the number of shared users to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIGPTSharedUser -GPTId "gpt-123456789"

        .EXAMPLE
        Get-OAIGPTSharedUser -GPTId "gpt-123456789" -Top 50

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$GPTId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI GPT manager"
        $gpt_manager = [OAIGPT]::new($script:client)

    } Process {
        Write-Debug "Retrieving GPT shared users for GPTId: $gptId"
        Try {
            If ($top) {
                $response = $gpt_manager.GetGPTSharedUsers($gptId, $top)
            
            } Else {
                $response = $gpt_manager.GetGPTSharedUsers($gptId, $null)
            
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving GPT shared users: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved GPT shared users"
        $response
    
    }
}