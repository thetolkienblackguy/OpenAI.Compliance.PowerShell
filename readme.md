# OpenAI.Compliance.PowerShell

[![PowerShell Gallery](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)]()

> **⚠️ DISCLAIMER:** This is an unofficial, third-party PowerShell module. It is not developed, maintained, endorsed, or supported by OpenAI. This project is independent and community-driven.

> **🚧 BETA RELEASE:** This module is in beta. There may be bugs, breaking changes, or incomplete functionality. Use with caution in production environments and always test thoroughly before deploying.

A comprehensive PowerShell module for interacting with the OpenAI ChatGPT Enterprise Compliance API. This module provides cmdlets for managing and exporting workspace data including conversations, GPTs, projects, users, memories, automations, recordings, and codex tasks.

## Table of Contents

- [Installation](#installation)
- [Authentication](#authentication)
- [Quick Start](#quick-start)
- [Module Architecture](#module-architecture)
- [Available Cmdlets](#available-cmdlets)
- [Usage Examples](#usage-examples)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Contributing](#contributing)
- [License](#license)

## Installation

```powershell
# Install from PowerShell Gallery for current user
Install-Module -Name OpenAI.Compliance.PowerShell -Scope CurrentUser

# Import the module
Import-Module OpenAI.Compliance.PowerShell
```

## Authentication

### Prerequisites

1. **ChatGPT Enterprise Workspace** - You must be an administrator of a ChatGPT Enterprise workspace
2. **API Key with Compliance Scopes** - Generate an API key through the OpenAI Platform Portal

### API Key Setup

1. Generate an API key in the [OpenAI API Platform Portal](https://platform.openai.com/api-keys)
   - Select the correct Organization corresponding to your administered workspace
   - Do NOT select your personal organization
   - Settings: Default Project | All Permissions
   - This must be a new key - existing keys cannot be granted compliance scopes

2. Contact OpenAI Support at <support@openai.com> with:
   - Last 4 digits of the API key
   - Key Name
   - Created By Name  
   - Requested scope (`read`, `delete`, or both)

3. OpenAI will verify and grant the compliance API scopes

### Initialize the Client

```powershell
Initialize-OAICompliance -WorkspaceId "12345678-1234-1234-1234-123456789012" -ApiKey "sk-proj-..."
```

## Quick Start

```powershell
# Initialize the compliance client
Initialize-OAICompliance -WorkspaceId "your-workspace-id" -ApiKey "your-api-key"

# Get all workspace users
$users = Get-OAIUser -All

# Get recent conversations
$recentConversations = Get-OAIConversation -SinceTimestamp (Get-Date).AddDays(-7)

# Get all GPTs
$gpts = Get-OAIGPT -All

# Get user automations
$automations = Get-OAIUserAutomation -UserId "user-123" -All

# Delete a specific conversation (with confirmation)
Remove-OAIConversation -ConversationId "conv-456"
```

## Module Architecture

### Class Structure

The module uses a layered architecture with three main components:

#### Core Client (`OAIComplianceRequestClient`)

- Handles authentication and HTTP requests
- Provides pagination support for list endpoints
- Manages rate limiting and error handling
- URL encoding for query parameters

#### Component Classes

- **OAIUser** - User management and file operations
- **OAIConversation** - Conversation data export and deletion
- **OAIGPT** - GPT management, configurations, and file operations
- **OAIProject** - Project management, configurations, and file operations
- **OAIMemory** - Workspace and user memory operations
- **OAIAutomation** - User automation management
- **OAICodex** - Codex task and environment operations
- **OAICanvas** - Canvas document operations
- **OAIRecording** - Recording management and transcript access

#### Public Functions

PowerShell cmdlets that wrap the component class methods, providing:

- Parameter validation and pipeline support
- Consistent error handling and debugging
- `ShouldProcess` support for destructive operations
- Standard PowerShell naming conventions

## Available Cmdlets

### User Management

- `Get-OAIUser` - List workspace users
- `Get-OAIUserFileContent` - Get user file content
- `Remove-OAIUserFile` - Delete user files

### Conversation Management  

- `Get-OAIConversation` - List conversations with filtering options
- `Remove-OAIConversation` - Delete conversations

### GPT Management

- `Get-OAIGPT` - List or get specific GPTs
- `Get-OAIGPTConfiguration` - Get GPT configuration versions
- `Get-OAIGPTFileContent` - Get GPT file content
- `Get-OAIGPTSharedUser` - List users with GPT access
- `Remove-OAIGPT` - Delete GPTs
- `Remove-OAIGPTFile` - Delete GPT files
- `Revoke-OAIGPTAccess` - Remove all shared access to GPT

### Project Management

- `Get-OAIProject` - List or get specific projects
- `Get-OAIProjectConfiguration` - Get project configuration versions
- `Get-OAIProjectFileContent` - Get project file content
- `Get-OAIProjectSharedUser` - List users with project access
- `Remove-OAIProject` - Delete projects
- `Remove-OAIProjectFile` - Delete project files
- `Revoke-OAIProjectAccess` - Remove all shared access to project

### Memory Management

- `Get-OAIMemory` - List workspace memories
- `Get-OAIUserMemory` - List user memories
- `Remove-OAIUserMemory` - Delete specific memory entries

### Automation Management

- `Get-OAIUserAutomation` - List user automations
- `Remove-OAIUserAutomation` - Delete user automations

### Canvas Management

- `Get-OAIUserCanvas` - List user canvases
- `Get-OAICanvasContent` - Get canvas content
- `Remove-OAICanvas` - Delete canvas documents

### Recording Management

- `Get-OAIRecording` - List workspace recordings
- `Get-OAIUserRecording` - List user recordings
- `Get-OAIUserRecordingTranscript` - Download recording transcripts
- `Remove-OAIRecording` - Delete workspace recordings
- `Remove-OAIUserRecording` - Delete user recordings

### Codex Management

- `Get-OAICodexTask` - List or get specific codex tasks
- `Get-OAICodexEnvironment` - List or get specific codex environments
- `Remove-OAICodexTask` - Delete codex tasks
- `Remove-OAICodexEnvironment` - Delete codex environments

### Initialization

- `Initialize-OAICompliance` - Initialize the API client

## Usage Examples

### User Operations

```powershell
# Get all users
$allUsers = Get-OAIUser -All

# Get first 50 users
$users = Get-OAIUser -Top 50

# Get user file content
$fileContent = Get-OAIUserFileContent -UserId "user-123" -FileId "file-456"

# Delete user file (with confirmation)
Remove-OAIUserFile -UserId "user-123" -FileId "file-456"

# Delete audio/video file with conversation context
Remove-OAIUserFile -UserId "user-123" -FileId "file-456" -ConversationId "conv-789"
```

### Conversation Operations

```powershell
# Get all conversations
$conversations = Get-OAIConversation -All

# Get conversations from last week
$recent = Get-OAIConversation -SinceTimestamp (Get-Date).AddDays(-7)

# Get limited number of recent conversations
$limited = Get-OAIConversation -SinceTimestamp (Get-Date).AddDays(-30) -SinceTop 100

# Delete conversation with confirmation
Remove-OAIConversation -ConversationId "conv-123"
```

### GPT Operations

```powershell
# Get all GPTs
$gpts = Get-OAIGPT -All

# Get specific GPT
$gpt = Get-OAIGPT -GPTId "gpt-123"

# Get GPT configurations
$configs = Get-OAIGPTConfiguration -GPTId "gpt-123"

# Get users who have access to GPT
$sharedUsers = Get-OAIGPTSharedUser -GPTId "gpt-123"

# Get GPT file content
$content = Get-OAIGPTFileContent -FileId "file-456"

# Delete GPT
Remove-OAIGPT -GPTId "gpt-123"

# Remove all shared access (isolate GPT)
Revoke-OAIGPTAccess -GPTId "gpt-123"
```

### Project Operations

```powershell
# Get all projects
$projects = Get-OAIProject -All

# Get specific project
$project = Get-OAIProject -ProjectId "proj-123"

# Get project configurations
$configs = Get-OAIProjectConfiguration -ProjectId "proj-123"

# Get project shared users
$sharedUsers = Get-OAIProjectSharedUser -ProjectId "proj-123"

# Delete project file
Remove-OAIProjectFile -ProjectId "proj-123" -FileId "file-456"

# Revoke all project access
Revoke-OAIProjectAccess -ProjectId "proj-123"
```

### Memory Operations

```powershell
# Get workspace memories
$workspaceMemories = Get-OAIMemory -All

# Get user memories
$userMemories = Get-OAIUserMemory -UserId "user-123" -All

# Delete specific memory entry
Remove-OAIUserMemory -UserId "user-123" -MemoryContextId "ctx-456" -MemoryId "memory-789"
```

### Automation Operations

```powershell
# Get user automations
$automations = Get-OAIUserAutomation -UserId "user-123" -All

# Delete automation
Remove-OAIUserAutomation -UserId "user-123" -AutomationId "auto-456"
```

### Canvas Operations

```powershell
# Get user canvases
$canvases = Get-OAIUserCanvas -UserId "user-123"

# Get canvas content
$content = Get-OAICanvasContent -UserId "user-123" -TextdocId "textdoc-456"

# Delete canvas
Remove-OAICanvas -UserId "user-123" -TextdocId "textdoc-456"
```

### Recording Operations

```powershell
# Get workspace recordings
$recordings = Get-OAIRecording -All

# Get user recordings
$userRecordings = Get-OAIUserRecording -UserId "user-123" -All

# Get recording transcript
$transcript = Get-OAIUserRecordingTranscript -UserId "user-123" -RecordingId "rec-456"

# Get transcript with summary
$transcriptWithSummary = Get-OAIUserRecordingTranscript -UserId "user-123" -RecordingId "rec-456" -IncludeSummary

# Delete recording
Remove-OAIUserRecording -UserId "user-123" -RecordingId "rec-456"
```

### Codex Operations

```powershell
# Get all codex tasks
$tasks = Get-OAICodexTask -All

# Get specific task
$task = Get-OAICodexTask -TaskId "task-123"

# Get codex environments
$environments = Get-OAICodexEnvironment -All

# Delete codex task
Remove-OAICodexTask -TaskId "task-123"

# Delete codex environment
Remove-OAICodexEnvironment -EnvironmentId "env-456"
```

## Error Handling

All cmdlets include comprehensive error handling:

### Common Error Scenarios

1. **Authentication Failures**

   ```powershell
   # Error: Failed to invoke request: Unauthorized
   # Solution: Verify API key has compliance scopes
   ```

2. **Rate Limiting**

   ```powershell
   # Error: Too many requests
   # Solution: Wait and retry, or implement delays between requests
   ```

### Debug Mode

Enable debug output for troubleshooting:

```powershell
Get-OAIUser -All -Debug
```

Debug output includes:

- Client initialization validation
- Request parameters and URLs
- Response status information
- Operation success/failure details

### ShouldProcess Support

Destructive operations support `-WhatIf` and `-Confirm`:

```powershell
# Preview what would be deleted
Remove-OAIConversation -ConversationId "conv-123" -WhatIf

# Force deletion without confirmation
Remove-OAIConversation -ConversationId "conv-123" -Confirm:$false

# Bulk operations with individual confirmations
Get-OAIGPT -All | Remove-OAIGPT -Confirm
```

## Rate Limiting

The OpenAI Compliance API has the following rate limits:

- **100 requests per minute per API key** for most endpoints
- Some endpoints may have lower limits

### Best Practices

1. **Use Top parameter** to limit result sets:

   ```powershell
   Get-OAIConversation -Top 50  # Instead of -All for large datasets
   ```

2. **Add delays for bulk operations**:

   ```powershell
   Remove-OAIConversation -ConversationId "conv-1"
   Start-Sleep -Milliseconds 500
   Remove-OAIConversation -ConversationId "conv-2"
   Start-Sleep -Milliseconds 500
   ```

3. **Use SinceTimestamp for incremental exports**:

   ```powershell
   $lastExport = Get-Date "2025-01-01"
   $newData = Get-OAIConversation -SinceTimestamp $lastExport
   ```

## Advanced Usage

### Data Export Workflows

```powershell
# Complete workspace export
$export = @{}
$export.Users = Get-OAIUser -All
$export.Conversations = Get-OAIConversation -All  
$export.GPTs = Get-OAIGPT -All
$export.Projects = Get-OAIProject -All
$export.Memories = Get-OAIMemory -All

# Save export data
$export | ConvertTo-Json -Depth 10 | Out-File "workspace_export.json"
```

### Incremental Sync

```powershell
# Get data modified since last sync
$lastSync = Get-Date "2025-08-01"
$newConversations = Get-OAIConversation -SinceTimestamp $lastSync
```

### Compliance Operations

```powershell
# Get data for specific user
$userId = "user-123"

# Retrieve user's data
$userMemories = Get-OAIUserMemory -UserId $userId -All  
$userAutomations = Get-OAIUserAutomation -UserId $userId -All
$userCanvases = Get-OAIUserCanvas -UserId $userId
$userRecordings = Get-OAIUserRecording -UserId $userId -All

# Delete user's data (each will prompt for confirmation)
$userMemories | Remove-OAIUserMemory
$userAutomations | Remove-OAIUserAutomation  
$userCanvases | Remove-OAICanvas
$userRecordings | Remove-OAIUserRecording
```

### Pipeline Operations

```powershell
# Remove functions support pipeline input for bulk operations
Get-OAIGPT -All | Remove-OAIGPT
Get-OAIProject -All | Remove-OAIProject
```

## Parameter Patterns

### Common Parameter Sets

Most Get cmdlets support these patterns:

```powershell
# Get all items
Get-OAIUser -All
Get-OAIGPT -All  
Get-OAIProject -All

# Limit results
Get-OAIUser -Top 50
Get-OAIGPT -Top 25
Get-OAIProject -Top 10

# Get specific item (where applicable)
Get-OAIGPT -GPTId "gpt-123"
Get-OAIProject -ProjectId "proj-456" 
Get-OAICodexTask -TaskId "task-789"
```

## Troubleshooting

### Common Issues

1. **Authentication Failures**

   ```powershell
   # Verify workspace ID format (UUID)
   # Verify API key has compliance scopes
   # Check if key was created in correct organization
   ```

2. **Rate Limiting**

   ```powershell
   # Add delays between requests
   # Use smaller Top values
   # Implement retry logic in your scripts
   ```

### Debug Information

The module includes built-in debugging capabilities. Use the `-Debug` parameter with any cmdlet to see detailed request information:

```powershell
# Enable debug output for any cmdlet
Get-OAIUser -All -Debug
Get-OAIConversation -Top 10 -Debug
Remove-OAIConversation -ConversationId "conv-123" -Debug
```

## Data Retention and Compliance

### Important Notes

- **Deleted data is not recoverable** - All delete operations are permanent
- **Audit logging** - All API requests are logged by OpenAI for security and compliance
- **Retention policies** - Deleted items are removed from all internal search and retrieval indexes

### Compliance Use Cases

This module is designed for:

- **Data archival** - Export workspace data for compliance storage
- **Data loss prevention** - Regular exports for backup purposes  
- **Spot deletion** - Remove specific sensitive content
- **User offboarding** - Clean up departing user's data
- **Audit support** - Generate reports for compliance reviews

## API Coverage

This module provides complete coverage of the OpenAI ChatGPT Enterprise Compliance API v1.1.5:

### Supported Endpoints

- ✅ Conversations (export, delete)
- ✅ Users (list, file operations)  
- ✅ GPTs (export, delete, configurations, files, sharing)
- ✅ Projects (export, delete, configurations, files, sharing)
- ✅ Memories (workspace and user-level export, delete)
- ✅ Automations (user-level export, delete)
- ✅ Canvas (user-level export, delete)
- ✅ Recordings (workspace and user-level export, delete, transcripts)
- ✅ Codex Tasks (export, delete)
- ✅ Codex Environments (export, delete)

### API Features

- ✅ Pagination support for all list endpoints
- ✅ Timestamp filtering for incremental exports
- ✅ File content retrieval via 307 redirects
- ✅ Proper URL encoding for query parameters
- ✅ Comprehensive error handling

## Requirements

- **PowerShell 5.1** or later
- **System.Web** assembly (for URL encoding)
- **ChatGPT Enterprise** workspace administrator access
- **API key** with compliance scopes granted by OpenAI

## Contributing

When contributing to this module:

1. **Follow the established coding patterns:**
   - PascalCase for parameters (`$UserId`, `$FileId`)
   - snake_case for local variables (`$user_manager`, `$invoke_rest_params`)
   - Consistent spacing (blank lines after opening/before closing braces)
   - Explicit parameter positioning and pipeline support

2. **Include comprehensive help:**
   - Synopsis, description, parameter details
   - Multiple usage examples
   - Input/output type information

3. **Support ShouldProcess for destructive operations:**
   - Use `[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]`
   - Implement proper confirmation messages
   - Support `-WhatIf` and `-Confirm` parameters

4. **Add debug logging:**
   - Log all major operations with `Write-Debug`
   - Include parameter values in debug messages
   - Log success/failure states

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

**Author:** Gabriel Delaney  
**Contact:** <gdelaney@phzconsulting.com>

For issues with this PowerShell module, please open an issue on GitHub.

For questions about the OpenAI Compliance API itself, contact <support@openai.com>.

---

**Note:** This module is designed for compliance and data management purposes. Always follow your organization's data handling policies and ensure proper authorization before performing delete operations.
