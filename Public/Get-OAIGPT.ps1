Function Get-OAIGPT {
    <#
        .SYNOPSIS
        Retrieves GPTs from the OpenAI Compliance API.

        .DESCRIPTION
        Retrieves workspace GPTs from the ChatGPT Enterprise compliance API. Can retrieve all GPTs,
        limit results, or get a specific GPT by ID.

        .PARAMETER All
        Retrieves all workspace GPTs.

        .PARAMETER Top
        Limits the number of GPTs to retrieve.

        .PARAMETER GPTId
        Retrieves a specific GPT by ID.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object[]

        .EXAMPLE
        Get-OAIGPT -All

        .EXAMPLE
        Get-OAIGPT -Top 25

        .EXAMPLE
        Get-OAIGPT -GPTId "gpt-123456789"

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Top")]
        [ValidateRange(0, 100)]
        [int]$Top,
        [Parameter(
            Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ById"
            
        )]
        [Alias("Id")]
        [string[]]$GPTId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI GPT manager"
        $gpt_manager = [OAIGPT]::new($script:client)

    } Process {
        Write-Debug "Retrieving workspace GPTs with parameter set: $($PSCmdlet.ParameterSetName)"
        Try {
            Switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    $gpt_manager.GetGPTs($null)

                } "Top" {
                    $gpt_manager.GetGPTs($top)

                } "ById" {
                    ForEach ($id in $gptId) {
                        $gpt_manager.GetGPT($id)
                    
                    }
                }
            }
            Write-Debug "Response retrieved successfully"
                
        } Catch {
            Write-Error "Error retrieving workspace GPTs: $($_.Exception.Message)" -ErrorAction Stop
        
        }
    } 
}