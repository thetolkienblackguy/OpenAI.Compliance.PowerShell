class OAIComplianceRequestClient {
    [string]$WorkspaceId
    [string]$BaseUri
    [system.collections.generic.list[pscustomobject]]$Results
    hidden [string]$APIKey
    hidden [hashtable]$Headers
    hidden [hashtable]$RequestDetails
    [int]$MaxRetries = 3

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
        For ($attempt = 1; $attempt -le $this.MaxRetries; $attempt++) {
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
                # Check if we should retry due to rate limiting
                If ($this.HandleRateLimit()) {
                    continue
                
                }
                
                # Log the error for non-retryable errors or final attempt
                Write-Error "Failed to invoke request: $($_.Exception.Message)"
                If ($attempt -eq $this.MaxRetries) {
                    return $null
                
                }
            }
        }  
        return $null
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
            
            If (!$response) {
                Write-Error "Failed to retrieve data during pagination"
                break
            
            } ElseIf ($response.data) {
                $items_to_add = $this.GetItemsToAdd($response.data, $top, $total_retrieved)
                
                Foreach ($item in $items_to_add) {
                    $this.Results.Add($item)
                
                }
                $total_retrieved += $items_to_add.Count
                
                # Check if we've reached the top limit
                If ($top -gt 0 -and $total_retrieved -ge $top) {
                    break
                
                }         
            }
            
            # Setup next page if more data exists
            If ($response.has_more -and $response.last_id) {
                $this.SetupNextPage($params, $response.last_id)
            
            }
        } While ($response.has_more -and $response.last_id)

        return $this.Results
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
    
    # Get the items to add based on top limit
    hidden [object[]]GetItemsToAdd([object[]]$data, [int]$top, [int]$total_retrieved) {
        If ($top -gt 0) {
            $remaining_needed = $top - $total_retrieved
            If ($remaining_needed -le 0) {
                return @()
            
            } ElseIf ($data.Count -gt $remaining_needed) {
                return $data[0..($remaining_needed - 1)]
            
            }
        }
        return $data
    }

    # Setup parameters for next page
    hidden [void]SetupNextPage([hashtable]$params, [string]$lastId) {
        # Remove since_timestamp to avoid parameter conflict
        If ($params.ContainsKey("since_timestamp")) {
            $params.Remove("since_timestamp")
        
        }
        $params["after"] = $lastId
    }
    #endregion

    #region Exception handling
    # Rate limiting method - reactive handling
    hidden [bool]HandleRateLimit() {
        $last_error = $Error[0]
        
        If ($this.IsRateLimitError($last_error)) {
            $retry_after = $this.GetRetryAfterValue($last_error)
            $sleep_time = If ($retry_after) { 
                [int]$retry_after 
            
            } Else { 
                60 
            
            }
            
            Write-Warning "Rate limit hit (429). Sleeping for $sleep_time seconds"
            Start-Sleep -Seconds $sleep_time
            
            return $true
        
        }
        
        return $false
    }

    # Check if error is a rate limit error
    hidden [bool]IsRateLimitError([object]$errorRecord) {
        If ($errorRecord.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            $status_code = $errorRecord.Exception.Response.StatusCode
            return ($status_code -eq 429)
        
        }
        return $false
    }

    # Get retry after value from error response
    hidden [object]GetRetryAfterValue([object]$errorRecord) {
        If ($errorRecord.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            return $errorRecord.Exception.Response.Headers["Retry-After"]
        
        }
        return $null
    }

    #region Debugging
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