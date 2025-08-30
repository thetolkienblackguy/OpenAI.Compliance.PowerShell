Function Get-OAIUserFileContent {
    <#
        .SYNOPSIS
        Retrieves user file content from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves the content of a user-owned file from the ChatGPT Enterprise compliance API.

        .PARAMETER UserId
        The ID of the user who owns the file.

        .PARAMETER FileId
        The ID of the file to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAIUserFileContent -UserId "user-123" -FileId "file-456"

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$FileId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI User manager"
        $user_manager = [OAIUser]::new($script:client)

    } Process {
        Write-Debug "Retrieving user file content for UserId: $userId, FileId: $fileId"
        Try {
            $response = $user_manager.GetUserFileContent($userId, $fileId)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving user file content: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved user file content"
        $response
    
    }
}