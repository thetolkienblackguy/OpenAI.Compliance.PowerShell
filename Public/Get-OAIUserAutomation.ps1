Function Get-OAIUserAutomation {
    <#
        .SYNOPSIS
        Retrieves user automations from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves automations for a specific user from the ChatGPT Enterprise compliance API.
        Can retrieve all automations or limit the number of results returned.

        .PARAMETER UserId
        The ID of the user whose automations to retrieve.

        .PARAMETER All
        Retrieves all user automations.

        .PARAMETER Top
        Limits the number of automations to retrieve.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUserAutomation -UserId "user-123" -All
        Retrieves all automations for the specified user.

        .EXAMPLE
        Get-OAIUserAutomation -UserId "user-123" -Top 25
        Retrieves the first 25 automations for the specified user.

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
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Top
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Automation manager"
        $automation_manager = [OAIAutomation]::new($script:client)

    } Process {
        Write-Debug "Retrieving user automations for UserId: $userId with parameter set: $($PSCmdlet.ParameterSetName)"
        If ($PSCmdlet.ParameterSetName -eq "All") {
            $top = 0
        
        }
        Foreach ($id in $userId) {
            Try {
                Write-Debug "Retrieving user automations for UserId: $id"
                $automation_manager.GetUserAutomations($id, $top)
            
            } Catch {
                Write-Error "Error retrieving user automations: $($_.Exception.Message)" -ErrorAction Stop
            
            }
        }
        Write-Debug "Response retrieved successfully"

    } 
}