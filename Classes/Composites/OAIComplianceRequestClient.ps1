class OAIComplianceRequestClient {
    [string]$WorkspaceId
    [string]$BaseUri
    [system.collections.generic.list[pscustomobject]]$Results
    hidden [string]$APIKey
    hidden [hashtable]$Headers
    hidden [hashtable]$RequestDetails
    hidden [int]$RequestCount = 0
    hidden [datetime]$RateLimitStartTime = [datetime]::Now

    OAIComplianceRequestClient([string]$workspaceId, [string]$apiKey) {
        $this.WorkspaceId = $workspaceId
        $this.BaseUri = "https://api.chatgpt.com/v1/compliance/workspaces/$($this.WorkspaceId)"
        $this.APIKey = $apiKey
        $this.Headers = @{}
        $this.Headers["Authorization"] = "Bearer $($this.APIKey)"
        $this.Headers["Content-Type"] = "application/json"
    }

    #region Request Methods
    # Invoke a request to the OpenAI Compliance API
    hidden [object]InvokeRequest([string]$method, [hashtable]$body, [string[]]$segments, [hashtable]$queryParams) {
        # Invoke-RestMethod parameters
        $invoke_rest_params = @{}
        $invoke_rest_params["Method"] = $method
        $invoke_rest_params["Uri"] = $this.BuildComplianceUri($segments, $queryParams)
        $invoke_rest_params["Headers"] = $this.Headers
        If ($body) {
            $invoke_rest_params["Body"] = $body
        
        }
        # Invoke-RestMethod
        Try {
            $this.RequestDetails = $invoke_rest_params
            $response = Invoke-RestMethod @invoke_rest_params
            return $response

        } Catch {
            # Log the error
            Write-Error "Failed to invoke request: $($_.Exception.Message)"
            return $null
        
        }
    }

    # Invoke a GET request to the OpenAI Compliance API
    [object]InvokeGetRequest([string[]]$segments, [hashtable]$queryParams) {
        return $this.InvokeRequest("GET", $null, $segments, $queryParams)
    
    }

    # Invoke a DELETE request to the OpenAI Compliance API
    hidden [object]InvokeDeleteRequest([string[]]$segments, [hashtable]$queryParams) {
        return $this.InvokeRequest("DELETE", $null, $segments, $queryParams)
    
    }

    # Paginate through all results for a GET request
    [object]Paginate([string[]]$segments, [hashtable]$queryParams, [int]$top = 0) {
        $this.Results = [system.collections.generic.list[pscustomobject]]::new()
        $params = $queryParams.Clone()
        $total_retrieved = 0  
        Do {
            $response = $this.InvokeGetRequest($segments, $params)
            # Handle rate limit
            $this.HandleRateLimit()
            
            If (!$response) {
                Write-Error "Failed to retrieve data during pagination"
            
            } ElseIf ($response.data) {
                Foreach ($item in $response.data) {
                    $this.Results.Add($item)
                
                }
                $total_retrieved += $response.data.Count
            
            }
            
            # Check if we've hit the top limit
            If ($top -gt 0 -and $total_retrieved -ge $top) {
                # Trim to exact top count
                $this.Results = $this.Results[0..($top - 1)]
                break
            
            }
            
            # Setup next page if more data exists
            If ($response.has_more -and $response.data.Count -gt 0) {
                $lastItem = $response.data[-1]
                # Use the ID of the last item for the 'after' parameter
                $params["after"] = $lastItem.id
            
            }
        } While ($response.has_more)

        return $this.Results
    }

    # Rate limiting method
    hidden [void]HandleRateLimit() {
        $this.RequestCount++
        
        # Check every 90 requests to stay under 100/minute limit
        If ($this.RequestCount % 90 -eq 0) {
            $elapsed = ([datetime]::Now - $this.RateLimitStartTime).TotalSeconds
            If ($elapsed -lt 60) {
                $sleep_time = 60 - $elapsed + 5  # Add 5 second buffer
                Write-Warning "Approaching rate limit. Sleeping for $sleep_time seconds"
                Start-Sleep -Seconds $sleep_time
            
            }
            # Reset tracking
            $this.RateLimitStartTime = [datetime]::Now
            $this.RequestCount = 0
        
        }
    }
    #endregion

    #region URI Building
    # Build the URI for the OpenAI Compliance API
    hidden [string]BuildComplianceUri([string[]]$segments, [hashtable]$queryParams) {
        $endpoint = "$($this.BaseUri)/$(($segments -replace '(^/+|/+$)', '') -join "/")"
  
        If ($queryParams) {
            $endpoint = "$($endpoint)?$(($queryParams.GetEnumerator() | ForEach-Object { 
                "$($_.Key)=$([System.Web.HttpUtility]::UrlEncode($_.Value.ToString()))" 
            
            }) -join "&")"
        
        }
        return $endpoint
    
    }

    #endregion

    #region Last Request
    # Get the last request
    [string]DebugRequest() {
        $masked_headers = $this.RequestDetails.Headers.Clone()
        $masked_headers.Authorization = $this.MaskApiKey($masked_headers.Authorization)
        $this.RequestDetails.Headers = $masked_headers
        return $this.RequestDetails | ConvertTo-Json -Depth 10
    
    }

    # Get the last results
    [string]DebugHeaders() {
        $masked_headers = $this.Headers.Clone()
        $masked_headers.Authorization = $this.MaskApiKey($masked_headers.Authorization)
        return $masked_headers | ConvertTo-Json -Depth 10
    
    }

    # Mask the API key
    [string]MaskApiKey([string]$apiKey) {
        return $apiKey.Substring(0, 7) + "******" + $apiKey.Substring($apiKey.Length - 4)
    
    }

    #endregion

    #region Static utilities
    # Convert datetime or int to unix timestamp
    static [int]ConvertToUnixTimestamp($sinceTimestamp) {
        If ($sinceTimestamp -is [datetime]) {
            return [int][double]::Parse((Get-Date $sinceTimestamp -UFormat %s))
        
        } Else {
            return $sinceTimestamp
        
        }
    
    }

    #endregion
}