Function Remove-OAIGPTFile {
    <#
        .SYNOPSIS
        Deletes a GPT file from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a file associated with a GPT from the ChatGPT Enterprise workspace. The file reference
        is also removed from all GPTs in the workspace.

        .PARAMETER GPTId
        The ID of the GPT that owns the file.

        .PARAMETER FileId
        The ID of the file to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIGPTFile -GPTId "gpt-123" -FileId "file-456"

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$GPTId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$FileId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI GPT manager"
        $gpt_manager = [OAIGPT]::new($script:client)

    } Process {
        ForEach ($gpt in $gptId) {
            ForEach ($file in $fileId) {
                Write-Debug "Deleting GPT file for GPTId: $gpt, FileId: $file"
                If ($PSCmdlet.ShouldProcess("Delete GPT file $file for GPT $gpt", "Remove-OAIGPTFile", "Delete GPT file")) {
                    Try {
                        $gpt_manager.DeleteGPTFile($gpt, $file)
                        Write-Debug "GPT file deleted successfully"
                    
                    } Catch {
                        Write-Error "Error deleting GPT file: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } 
            }
        }
    } 
}