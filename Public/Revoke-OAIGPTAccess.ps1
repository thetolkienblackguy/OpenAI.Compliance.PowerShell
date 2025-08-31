Function Revoke-OAIGPTAccess {
    <#
        .SYNOPSIS
        Revokes shared access to a GPT from the OpenAI Compliance API.

        .DESCRIPTION
        Removes access to a GPT for all share recipients (users, groups, etc.) from the ChatGPT Enterprise workspace.
        The GPT is still available for use by the owner.

        .PARAMETER GPTId
        The ID of the GPT to revoke access for.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Revoke-OAIGPTAccess -GPTId "gpt-123456789"

        .EXAMPLE
        Get-OAIGPT -All | Revoke-OAIGPTAccess

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$GPTId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI GPT manager"
        $gpt_manager = [OAIGPT]::new($script:client)

    } Process {
        ForEach ($id in $gptId) {
            Write-Debug "Revoking GPT access: $id"
            Try {
                If ($PSCmdlet.ShouldProcess("Revoke access to GPT $id (remove all shared users)", "Revoke-OAIGPTAccess", "Revoke GPT access")) {
                    Try {
                        $response = $gpt_manager.IsolateGPT($id)
                        Write-Debug "GPT access revoked successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error revoking GPT access: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping GPT access revocation due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error isolating GPT: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
    } End {
        Write-Debug "Successfully processed GPT access revocation"
    
    }
}