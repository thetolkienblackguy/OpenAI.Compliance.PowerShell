Function Remove-OAIUserMemory {
    <#
        .SYNOPSIS
        Deletes a user memory entry from the OpenAI Compliance API.

        .DESCRIPTION
        Deletes a specific memory entry for a user from the ChatGPT Enterprise workspace.

        .PARAMETER UserId
        The ID of the user who owns the memory.

        .PARAMETER MemoryContextId
        The ID of the memory context. Note: This could be a user ID if it refers to the user's primary memory context.

        .PARAMETER MemoryId
        The ID of the memory to delete.

        .INPUTS
        System.String
        
        .OUTPUTS
        System.Object

        .EXAMPLE
        Remove-OAIUserMemory -UserId "user-123" -MemoryContextId "ctx-456" -MemoryId "memory-789"

        .EXAMPLE
        Get-OAIUserMemory -UserId "user-123" -All | Remove-OAIUserMemory

    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$UserId,
        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$MemoryContextId,
        [Parameter(Mandatory=$true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$MemoryId
    
    )
    Begin {
        Write-Debug "Validating OpenAI Compliance client initialization"
        If (!$script:client) {
            Write-Error "OpenAI Compliance client not initialized. Please run Initialize-OAICompliance first." -ErrorAction Stop
            
        }
        Write-Debug "Creating OAI Memory manager"
        $memory_manager = [OAIMemory]::new($script:client)

    } Process {
        ForEach ($user in $userId) {
            ForEach ($context in $memoryContextId) {
                ForEach ($memory in $memoryId) {
                    Write-Debug "Deleting user memory for UserId: $user, MemoryContextId: $context, MemoryId: $memory"
                    Try {
                        If ($PSCmdlet.ShouldProcess("Delete memory $memory for user $user in context $context", "Remove-OAIUserMemory", "Delete user memory")) {
                            Try {
                                $response = $memory_manager.DeleteMemoryEntry($user, $context, $memory)
                                Write-Debug "Memory deleted successfully"
                                $response
                            
                            } Catch {
                                Write-Error "Error deleting user memory: $($_.Exception.Message)" -ErrorAction Stop
                            
                            }
                        } Else {
                            Write-Debug "Skipping user memory deletion due to ShouldProcess"
                        
                        }
                    } Catch {
                        Write-Error "Error deleting user memory: $($_.Exception.Message)" -ErrorAction Stop
                    
                    }
                }
            }
        }
    } End {
        Write-Debug "Successfully processed user memory deletion"
    
    }
}