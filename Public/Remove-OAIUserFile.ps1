Function Remove-OAIUserFile {
    <#
        .SYNOPSIS
        Deletes a user-owned file from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a user-owned file from the ChatGPT Enterprise workspace. For audio and video files,
        a conversation ID may be required.

        .PARAMETER UserId
        The ID of the user who owns the file.

        .PARAMETER FileId
        The ID of the file to delete.

        .PARAMETER ConversationId
        The ID of the conversation (required for audio and video files).

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIUserFile -UserId "user-123" -FileId "file-456"

        .EXAMPLE
        Remove-OAIUserFile -UserId "user-123" -FileId "file-456" -ConversationId "conv-789"

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$FileId,
        [Parameter(Mandatory=$false, Position=2, ValueFromPipelineByPropertyName=$true)]
        [string]$ConversationId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI User manager"
        $user_manager = [OAIUser]::new($script:client)

    } Process {
        ForEach ($user in $userId) {
            ForEach ($file in $fileId) {
                Write-Debug "Deleting user file for UserId: $user, FileId: $file"
                Try {
                    If ($PSCmdlet.ShouldProcess("Delete user file $file for user $user", "Remove-OAIUserFile", "Delete user file")) {
                        Try {
                            If ($conversationId) {
                                $response = $user_manager.DeleteUserFile($user, $file, $conversationId)
                            
                            } Else {
                                $response = $user_manager.DeleteUserFile($user, $file, $null)
                            
                            }
                            Write-Debug "File deleted successfully"
                            $response
                        
                        } Catch {
                            Write-Error "Error deleting user file: $($_.Exception.Message)" -ErrorAction Stop
                        
                        }
                    } Else {
                        Write-Debug "Skipping user file deletion due to ShouldProcess"
                    
                    }
                } Catch {
                    Write-Error "Error deleting user file: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            }
        }

    } End {
        Write-Debug "Successfully processed user file deletion"
    
    }
}