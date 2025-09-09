Function Get-OAIConversation {
    <#
        .SYNOPSIS
        Retrieves conversations from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves workspace conversations from the ChatGPT Enterprise compliance API. Can retrieve all conversations,
        limit results, or filter by timestamp.

        .PARAMETER All
        Retrieves all workspace conversations.

        .PARAMETER Top
        Limits the number of conversations to retrieve.

        .PARAMETER SinceTimestamp
        Retrieves conversations updated since the specified timestamp. Accepts DateTime or Unix timestamp (int).

        .INPUTS
        System.DateTime, System.Int32
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIConversation -All

        .EXAMPLE
        Get-OAIConversation -Top 50

        .EXAMPLE
        Get-OAIConversation -SinceTimestamp (Get-Date).AddDays(-7)

        .EXAMPLE
        Get-OAIConversation -SinceTimestamp 1735689600

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Since")]
        $SinceTimestamp,
        [Parameter(Mandatory=$false, Position=1, ParameterSetName="Since")]
        [ValidateRange(0, 100)]
        [int]$SinceTop
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Conversation manager"
        $conversation_manager = [OAIConversation]::new($script:client)

    } Process {
        Write-Debug "Retrieving workspace conversations with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    Write-Warning "Retrieving all workspace conversations depending on the size of the workspace, this may take a while. Recommended to use the Top parameter to limit the number of conversations retrieved."
                    $conversation_manager.GetConversations($null)

                } "Top" {
                    $conversation_manager.GetConversations($top)

                } "Since" {
                    If ($sinceTop) {
                        $conversation_manager.GetConversationsSince($sinceTimestamp, $sinceTop)
                    
                    } Else {
                        $conversation_manager.GetConversationsSince($sinceTimestamp, $null)
                    
                    }
                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving workspace conversations: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}