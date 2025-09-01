Function Get-OAIUserRecording {
    <#
        .SYNOPSIS
        Retrieves user recordings from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves recordings for a specific user from the ChatGPT Enterprise compliance API.
        Can retrieve all recordings or limit the number of results returned.

        .PARAMETER UserId
        The ID of the user whose recordings to retrieve.

        .PARAMETER All
        Retrieves all user recordings.

        .PARAMETER Top
        Limits the number of recordings to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUserRecording -UserId "user-123" -All
        Retrieves all recordings for the specified user.

        .EXAMPLE
        Get-OAIUserRecording -UserId "user-123" -Top 25
        Retrieves the first 25 recordings for the specified user.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=1, ParameterSetName="Top")]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Recording manager"
        $recording_manager = [OAIRecording]::new($script:client)

    } Process {
        Write-Debug "Retrieving user recordings for UserId: $userId with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $response = $recording_manager.GetUserRecordings($userId, $null)

                } "Top" {
                    $response = $recording_manager.GetUserRecordings($userId, $top)

                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving user recordings: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved user recordings"
        $response
    
    }
}