Function Get-OAIProject {
    <#
        .SYNOPSIS
        Retrieves projects from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves workspace projects from the ChatGPT Enterprise compliance API. Can retrieve all projects,
        limit results, or get a specific project by ID.

        .PARAMETER All
        Retrieves all workspace projects.

        .PARAMETER Top
        Limits the number of projects to retrieve.

        .PARAMETER ProjectId
        Retrieves a specific project by ID.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIProject -All

        .EXAMPLE
        Get-OAIProject -Top 25

        .EXAMPLE
        Get-OAIProject -ProjectId "proj-123456789"

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Top,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="ById")]
        [string]$ProjectId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Project manager"
        $project_manager = [OAIProject]::new($script:client)

    } Process {
        Write-Debug "Retrieving workspace projects with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $response = $project_manager.GetProjects($null)

                } "Top" {
                    $response = $project_manager.GetProjects($top)

                } "ById" {
                    $response = $project_manager.GetProject($projectId)

                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving workspace projects: $($_.Exception.Message)" -ErrorAction Stop
        
        }

    } End {
        Write-Debug "Successfully retrieved workspace projects"
        $response
    
    }
}