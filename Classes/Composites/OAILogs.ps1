class OAILogs {
    [OAIComplianceRequestClient]$Client

    OAILogs([OAIComplianceRequestClient]$client) {
        $this.Client = $client
    
    }

    #region Log File Operations
    # Get log files for a specific event type with optional time filters
    [object]GetLogFiles([string]$eventType, [datetime]$after, [datetime]$before, [int]$top = 0) {
        $query_params = @{}
        $query_params["event_type"] = $eventType
        $query_params["after"] = [OAIComplianceRequestClient]::ConvertToIso8601($after)
        $query_params["limit"] = 100
        
        If ($before) {
            $query_params["before"] = [OAIComplianceRequestClient]::ConvertToIso8601($before)
        
        }
        
        return $this.Client.Paginate(@("logs"), $query_params, $top)
    
    }

    # Download and parse log file content
    [object]GetLogFileContent([string]$logFileId, [bool]$deduplicate) {
        $segments = @("logs", $logFileId)
        $raw_content = $this.Client.InvokeFileDownload($segments, @{})
        
        If (!$raw_content) {
            Write-Error "Failed to download log file content"
            return $null
        
        }
        
        # Parse JSONL content
        $events = $this.ParseJsonLines($raw_content)
        
        # Deduplicate if requested
        If ($deduplicate) {
            $events = $this.DeduplicateEvents($events)
        
        }
        
        return $events
    
    }

    # Parse JSONL content into PowerShell objects
    hidden [object[]]ParseJsonLines([string]$jsonlContent) {
        $events = [system.collections.generic.list[pscustomobject]]::new()
        $lines = $jsonlContent -split "`n"
        
        Foreach ($line in $lines) {
            If (![string]::IsNullOrWhiteSpace($line)) {
                Try {
                    $log_event = $line | ConvertFrom-Json
                    $events.Add($log_event)
                
                } Catch {
                    Write-Warning "Failed to parse JSON line: $line"
                
                }
            
            }
        
        }
        
        return $events.ToArray()
    
    }

    # Deduplicate events by event_id
    hidden [object[]]DeduplicateEvents([object[]]$events) {
        $unique_events = @{}
        $deduplicated = [system.collections.generic.list[pscustomobject]]::new()
        
        Foreach ($log_event in $events) {
            If ($log_event.event_id -and !$unique_events.ContainsKey($log_event.event_id)) {
                $unique_events[$log_event.event_id] = $true
                $deduplicated.Add($log_event)
            
            }
        
        }
        
        return $deduplicated.ToArray()
    
    }
    #endregion
}