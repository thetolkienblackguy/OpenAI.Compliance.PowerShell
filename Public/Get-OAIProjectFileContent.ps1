Function Get-OAIProjectFileContent {
    <#
        .SYNOPSIS
        Retrieves project file content from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves the content of a file associated with a project from the ChatGPT Enterprise compliance API.

        .PARAMETER FileId
        The ID of the project file to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAIProjectFileContent -FileId "file-123456789"

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FileId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Project manager"
        $project_manager = [OAIProject]::new($script:client)

    } Process {
        Write-Debug "Retrieving project file content for FileId: $fileId"
        Try {
            $response = $project_manager.GetProjectFileContent($fileId)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving project file content: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved project file content"
        $response
    
    }
}