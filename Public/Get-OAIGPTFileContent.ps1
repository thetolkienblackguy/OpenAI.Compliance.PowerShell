Function Get-OAIGPTFileContent {
    <#
        .SYNOPSIS
        Retrieves GPT file content from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves the content of a file associated with a GPT from the ChatGPT Enterprise compliance API.

        .PARAMETER FileId
        The ID of the GPT file to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAIGPTFileContent -FileId "file-123456789"

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string[]]$FileId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI GPT manager"
        $gpt_manager = [OAIGPT]::new($script:client)

    } Process {
        ForEach ($id in $fileId) {
            Write-Debug "Retrieving GPT file content for FileId: $id"
            Try {
                $gpt_manager.GetGPTFileContent($id)
            
            } Catch {
                Write-Error "Error retrieving GPT file content: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
    } 
}