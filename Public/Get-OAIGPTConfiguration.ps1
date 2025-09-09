Function Get-OAIGPTConfiguration {
    <#
        .SYNOPSIS
        Retrieves GPT configurations from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves all configuration versions for a specific GPT from the ChatGPT Enterprise compliance API.

        .PARAMETER GPTId
        The ID of the GPT whose configurations to retrieve.

        .PARAMETER Top
        Limits the number of configurations to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIGPTConfiguration -GPTId "gpt-123456789"

        .EXAMPLE
        Get-OAIGPTConfiguration -GPTId "gpt-123456789" -Top 10

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
            Write-Debug "Retrieving GPT configurations for GPTId: $id"
            Try {
                $gpt_manager.GetGPTConfigurations($id, $top)
            
            } Catch {
                Write-Error "Error retrieving GPT configurations: $($_.Exception.Message)" -ErrorAction Stop
            
            }
            Write-Debug "Response retrieved successfully"
        
        }
    } 
}