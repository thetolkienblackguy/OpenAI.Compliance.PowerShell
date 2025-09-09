Function Get-OAIRecording {
    <#
        .SYNOPSIS
        Retrieves recordings from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves recordings from the ChatGPT Enterprise compliance API. Can retrieve all recordings,
        limit the number of results returned, or get a specific recording by ID.

        .PARAMETER All
        Retrieves all workspace recordings.

        .PARAMETER Top
        Limits the number of recordings to retrieve.

        .PARAMETER RecordingId
        Retrieves a specific recording by ID.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-OAIRecording -All
        Retrieves all workspace recordings.

        .EXAMPLE
        Get-OAIRecording -Top 50
        Retrieves the first 50 workspace recordings.

        .EXAMPLE
        Get-OAIRecording -RecordingId "recording-123"
        Retrieves a specific recording by ID.

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="ById", ValueFromPipelineByPropertyName=$true)]
        [string]$RecordingId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Recording manager"
        $recording_manager = [OAIRecording]::new($script:client)

    } Process {
        Write-Debug "Retrieving recordings with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $recording_manager.GetRecordings($null)

                } "Top" {
                    $recording_manager.GetRecordings($top)

                } "ById" {
                    $recording_manager.GetRecording($recordingId)

                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving recordings: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}