Function Get-OAIUserConversation {
    <#
        .SYNOPSIS
        Retrieves conversations for a specific user from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves workspace conversations for a specified user from the ChatGPT Enterprise compliance API. 
        Can retrieve all conversations for the user or limit the number of results.

        .PARAMETER UserId
        User ID to retrieve conversations for.

        .PARAMETER All
        Retrieves all conversations for the specified user.

        .PARAMETER Top
        Limits the number of conversations to retrieve.

        .INPUTS
        System.String, System.Int32
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUserConversation -UserId "user-XXXXXXXXXXXXXXXXXXXXXXXX" -All

        .EXAMPLE
        Get-OAIUserConversation -UserId "user-XXXXXXXXXXXXXXXXXXXXXXXX" -Top 50

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string[]]$UserId,
        [Parameter(Mandatory=$true, Position=1, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=1, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Conversation manager"
        $conversation_manager = [OAIConversation]::new($script:client)

    } Process {
        Write-Debug "Retrieving user conversations with parameter set: $($PSCmdlet.ParameterSetName)"
        If ($PSCmdlet.ParameterSetName -eq "All") {
            $top = 0
        
        }
        Foreach ($id in $userId) {
            Try {
                Write-Debug "Retrieving user conversations for UserId: $id"
                $conversation_manager.GetConversationsByUser($id, $top)
            
            } Catch {
                Write-Error "Error retrieving user conversations: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        
        }            
        Write-Debug "Response retrieved successfully"
    } 
}