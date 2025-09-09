Function Remove-OAICodexEnvironment {
    <#
        .SYNOPSIS
        Deletes a codex environment from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a codex environment from the ChatGPT Enterprise workspace.

        .PARAMETER EnvironmentId
        The ID of the environment to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAICodexEnvironment -EnvironmentId "env-123"

        .EXAMPLE
        Get-OAICodexEnvironment -All | Remove-OAICodexEnvironment

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$EnvironmentId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Codex manager"
        $codex_manager = [OAICodex]::new($script:client)

    } Process {
        ForEach ($environment in $environmentId) {
            Write-Debug "Deleting codex environment for EnvironmentId: $environment"
            If ($PSCmdlet.ShouldProcess("Delete codex environment $environment", "Remove-OAICodexEnvironment", "Delete codex environment")) {
                Try {
                    $codex_manager.DeleteCodexEnvironment($environment)
                    Write-Debug "Codex environment deleted successfully"
                
                } Catch {
                    Write-Error "Error deleting codex environment: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            } 
        }
    } 
}