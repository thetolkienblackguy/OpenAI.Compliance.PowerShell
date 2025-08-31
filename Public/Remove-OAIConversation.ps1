Function Remove-OAIConversation {
    <#
        .SYNOPSIS
        Deletes a conversation from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a conversation from the ChatGPT Enterprise workspace. This removes the conversation title,
        messages, files, and shared links. A placeholder will remain in the history for 30 days.

        .PARAMETER ConversationId
        The ID of the conversation to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIConversation -ConversationId "conv-123456789"

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$ConversationId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Conversation manager"
        $conversation_manager = [OAIConversation]::new($script:client)

    } Process {
        ForEach ($id in $conversationId) {
            Write-Debug "Deleting conversation: $id"
            Try {
                If ($PSCmdlet.ShouldProcess("Delete conversation $id", "Remove-OAIConversation", "Delete conversation")) {
                    Try {
                        $response = $conversation_manager.DeleteConversation($id)
                        Write-Debug "Conversation deleted successfully"
                        $response
                    
                    } Catch {
                        Write-Error "Error deleting conversation: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                } Else {
                    Write-Debug "Skipping conversation deletion due to ShouldProcess"
                
                }
            } Catch {
                Write-Error "Error deleting conversation: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }

    } End {
        Write-Debug "Successfully processed conversation deletion"
    
    }
}