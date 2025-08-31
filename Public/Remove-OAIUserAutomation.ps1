Function Remove-OAIUserAutomation {
    <#
        .SYNOPSIS
        Deletes a user automation from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a specific automation for a user from the ChatGPT Enterprise workspace.

        .PARAMETER UserId
        The ID of the user who owns the automation.

        .PARAMETER AutomationId
        The ID of the automation to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIUserAutomation -UserId "user-123" -AutomationId "automation-456"

        .EXAMPLE
        Get-OAIUserAutomation -UserId "user-123" -All | Remove-OAIUserAutomation

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$AutomationId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Automation manager"
        $automation_manager = [OAIAutomation]::new($script:client)

    } Process {
        ForEach ($user in $userId) {
            ForEach ($automation in $automationId) {
                Write-Debug "Deleting user automation for UserId: $user, AutomationId: $automation"
                Try {
                    If ($PSCmdlet.ShouldProcess("Delete automation $automation for user $user", "Remove-OAIUserAutomation", "Delete user automation")) {
                        Try {
                            $response = $automation_manager.DeleteUserAutomation($user, $automation)
                            Write-Debug "Automation deleted successfully"
                            $response
                        
                        } Catch {
                            Write-Error "Error deleting user automation: $($_.Exception.Message)" -ErrorAction Stop
                        
                        }
                    } Else {
                        Write-Debug "Skipping user automation deletion due to ShouldProcess"
                    
                    }
                } Catch {
                    Write-Error "Error deleting user automation: $($_.Exception.Message)" -ErrorAction Stop
                
                }
            }
        }

    } End {
        Write-Debug "Successfully processed user automation deletion"
    
    }
}