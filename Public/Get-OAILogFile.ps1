Function Get-OAILogFile {
    <#
        .SYNOPSIS
        Retrieves compliance log file metadata from the OpenAI Compliance API v2.

        .DESCRIPTION
        Retrieves metadata for compliance log files that have been exported for a workspace. 
        Each item corresponds to a JSON Lines file containing compliance events for the specified 
        event type. Can retrieve all log files or limit the number of results returned.

        .PARAMETER EventType
        The type of compliance log files to retrieve. Valid values are "AUDIT_LOG" and "AUTH_LOG".

        .PARAMETER After
        Return log files whose end_time is strictly later than this datetime. Required for filtering.

        .PARAMETER Before
        Optional upper bound for filtering results. Only log files with an end_time strictly 
        earlier than this datetime are returned.

        .PARAMETER All
        Retrieves all log files matching the criteria.

        .PARAMETER Top
        Limits the number of log files to retrieve.

        .INPUTS
        None
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAILogFile -EventType "AUDIT_LOG" -After (Get-Date).AddDays(-7) -All
        Retrieves all audit log files from the last 7 days.

        .EXAMPLE
        Get-OAILogFile -EventType "AUTH_LOG" -After (Get-Date).AddDays(-1) -Before (Get-Date) -Top 50
        Retrieves the first 50 auth log files from the last 24 hours.

        .EXAMPLE
        Get-OAILogFile -EventType "AUDIT_LOG" -After "2025-01-01" -All
        Retrieves all audit log files since January 1, 2025.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet("AUDIT_LOG", "AUTH_LOG")]
        [string]$EventType,
        [Parameter(Mandatory=$true, Position=1)]
        [datetime]$After,
        [Parameter(Mandatory=$false, Position=2)]
        [datetime]$Before = (Get-Date),
        [Parameter(Mandatory=$true, Position=3, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=3, ParameterSetName="Top")]
        [ValidateRange(1, 100)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Logs manager"
        $logs_manager = [OAILogs]::new($script:client)

    } Process {
        Write-Debug "Retrieving log files with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            If ($PSCmdlet.ParameterSetName -eq "All") {
                $top = 0
            
            }
            
            $logs_manager.GetLogFiles($eventType, $after, $before, $top)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving log files: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } 
}