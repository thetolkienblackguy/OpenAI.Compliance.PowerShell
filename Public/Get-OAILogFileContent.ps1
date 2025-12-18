Function Get-OAILogFileContent {
    <#
        .SYNOPSIS
        Downloads and parses compliance log file content from the OpenAI Compliance API v2.

        .DESCRIPTION
        Downloads a specific compliance log file and parses the JSON Lines content into 
        PowerShell objects. Each log entry becomes a separate object. Optionally deduplicates 
        events by event_id to handle the "at least once" delivery guarantee.

        .PARAMETER LogFileId
        The ID of the log file to download. This is returned by Get-OAILogFile.

        .PARAMETER Deduplicate
        When specified, removes duplicate events based on event_id. Use this when processing 
        multiple log files to ensure each event is only processed once.

        .INPUTS
        None
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAILogFileContent -LogFileId "log_abc123"
        Downloads and parses the specified log file.

        .EXAMPLE
        Get-OAILogFileContent -LogFileId "log_abc123" -Deduplicate
        Downloads and parses the log file, removing any duplicate events.

        .EXAMPLE
        Get-OAILogFile -EventType "AUDIT_LOG" -After (Get-Date).AddDays(-1) -All | 
            ForEach-Object { Get-OAILogFileContent -LogFileId $_.id -Deduplicate }
        Retrieves all audit logs from the last day and downloads their content with deduplicatio}

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias("id")]
        [string]$LogFileId,
        [Parameter(Mandatory=$false)]
        [switch]$Deduplicate
    
        
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Logs manager"
        $logs_manager = [OAILogs]::new($script:client)

    } Process {
        Write-Debug "Downloading log file content for: $logFileId"
        Try {
            $logs_manager.GetLogFileContent($logFileId, $deduplicate.IsPresent)
            Write-Debug "Log file content retrieved and parsed successfully"
                
        } Catch {
            Write-Error "Error retrieving log file content: $($_.Exception.Message)" -ErrorAction Stop
        
        
        }
    } 
}