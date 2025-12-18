Function Get-OAICodexTask {
    <#
        .SYNOPSIS
        Retrieves codex tasks from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves codex tasks from the ChatGPT Enterprise compliance API. Can retrieve all tasks,
        limit the number of results returned, or get a specific task by ID.

        .PARAMETER All
        Retrieves all workspace codex tasks.

        .PARAMETER Top
        Limits the number of tasks to retrieve.

        .PARAMETER TaskId
        Retrieves a specific task by ID.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAICodexTask -All
        Retrieves all workspace codex tasks.

        .EXAMPLE
        Get-OAICodexTask -Top 25
        Retrieves the first 25 workspace codex tasks.

        .EXAMPLE
        Get-OAICodexTask -TaskId "task-123"
        Retrieves a specific task by ID.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top,
        [Parameter(
            Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ById"
            
        )]
        [Alias("Id")]
        [string]$TaskId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Codex manager"
        $codex_manager = [OAICodex]::new($script:client)

    } Process {
        Write-Debug "Retrieving codex tasks with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $codex_manager.GetCodexTasks($null)

                } "Top" {
                    $codex_manager.GetCodexTasks($top)

                } "ById" {
                    $codex_manager.GetCodexTask($taskId)

                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving codex tasks: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}