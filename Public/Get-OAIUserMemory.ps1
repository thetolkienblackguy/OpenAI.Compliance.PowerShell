Function Get-OAIUserMemory {
    <#
        .SYNOPSIS
        Retrieves user memories from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves memories for a specific user from the ChatGPT Enterprise compliance API.
        Can retrieve all memories or limit the number of results returned.

        .PARAMETER UserId
        The ID of the user whose memories to retrieve.

        .PARAMETER All
        Retrieves all user memories.

        .PARAMETER Top
        Limits the number of memories to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUserMemory -UserId "user-123" -All
        Retrieves all memories for the specified user.

        .EXAMPLE
        Get-OAIUserMemory -UserId "user-123" -Top 50
        Retrieves the first 50 memories for the specified user.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
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
        Write-Debug "Creating OAI Memory manager"
        $memory_manager = [OAIMemory]::new($script:client)

    } Process {
        Write-Debug "Retrieving user memories for UserId: $userId with parameter set: $($PSCmdlet.ParameterSetName)"
        If ($PSCmdlet.ParameterSetName -eq "All") {
            $top = 0
            
        }
        ForEach ($id in $userId) {
            Try {
                Write-Debug "Retrieving user memories for UserId: $id"
                $memory_manager.GetUserMemories($id, $top)
            
            } Catch {
                Write-Error "Error retrieving user memories: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
    } 
}