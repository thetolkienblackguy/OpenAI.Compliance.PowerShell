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
        [string[]]$GPTId,
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateRange(0, 100)]
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
        If (!$top) {
            $top = 0
        
        }
        ForEach ($id in $gptId) {
            Write-Debug "Retrieving GPT shared users for GPTId: $id"
            Try {
                $gpt_manager.GetGPTSharedUsers($id, $top)
            
            } Catch {
                Write-Error "Error retrieving GPT shared users: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
    }
}