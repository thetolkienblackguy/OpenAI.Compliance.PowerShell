Function Get-OAIMemory {
    <#
        .SYNOPSIS
        Retrieves workspace memories from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves all memories for the workspace from the ChatGPT Enterprise compliance API. 
        Can retrieve all memories or limit the number of results returned.

        .PARAMETER All
        Retrieves all workspace memories.

        .PARAMETER Top
        Limits the number of memories to retrieve.

        .INPUTS
        None
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIMemory -All
        Retrieves all workspace memories.

        .EXAMPLE
        Get-OAIMemory -Top 100
        Retrieves the first 100 workspace memories.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
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
        Write-Debug "Retrieving workspace memories with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            If (!$top) {
                $top = 0
                
            }
            $memory_manager.GetMemories($top)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving workspace memories: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}