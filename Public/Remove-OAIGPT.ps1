Function Remove-OAIGPT {
    <#
        .SYNOPSIS
        Deletes a GPT from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a GPT from the ChatGPT Enterprise workspace, including all associated files. 
        Does not delete conversations that used the GPT.

        .PARAMETER GPTId
        The ID of the GPT to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIGPT -GPTId "gpt-123456789"

        .EXAMPLE
        Get-OAIGPT -All | Remove-OAIGPT

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
            Write-Debug "Deleting GPT: $id"
            If ($PSCmdlet.ShouldProcess("Delete GPT $id", "Remove-OAIGPT", "Delete GPT")) {
                Try {
                    $gpt_manager.DeleteGPT($id)
                    Write-Debug "GPT deleted successfully"
                
                } Catch {
                    Write-Error "Error deleting GPT: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            }
        }
    } 
}