Function Get-OAIUser {
    <#
        .SYNOPSIS
        Retrieves users from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves workspace users from the ChatGPT Enterprise compliance API. Can retrieve all users 
        or limit the number of results returned.

        .PARAMETER All
        Retrieves all workspace users.

        .PARAMETER Top
        Limits the number of users to retrieve.

        .INPUTS
        None
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIUser -All
        Retrieves all workspace users.

        .EXAMPLE
        Get-OAIUser -Top 100
        Retrieves the first 100 workspace users.

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
        Write-Debug "Creating OAI User manager"
        $user_manager = [OAIUser]::new($script:client)

    } Process {
        Write-Debug "Retrieving workspace users with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            If ($PSCmdlet.ParameterSetName -eq "All") {
                $top = 0
            
            }
            $user_manager.GetUsers($top)
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving workspace users: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } 
}