# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## Added

## Changed

## Deprecated

## Removed

## Fixed

## Security

## [0.0.1] - 2025-08-31

### Added

- Initial beta release of OpenAI.Compliance.PowerShell module
- Complete PowerShell wrapper for OpenAI ChatGPT Enterprise Compliance API v1.1.5
- Core client (`OAIComplianceRequestClient`) with authentication, pagination, and URL encoding
- Component classes for all API resources:
  - `OAIUser` - User management and file operations
  - `OAIConversation` - Conversation export and deletion
  - `OAIGPT` - GPT management, configurations, and file operations
  - `OAIProject` - Project management, configurations, and file operations
  - `OAIMemory` - Workspace and user memory operations
  - `OAIAutomation` - User automation management
  - `OAICodex` - Codex task and environment operations
  - `OAICanvas` - Canvas document operations
  - `OAIRecording` - Recording management and transcript access
- 37 public PowerShell cmdlets covering all API endpoints:
  - User Management: `Get-OAIUser`, `Get-OAIUserFileContent`, `Remove-OAIUserFile`
  - Conversation Management: `Get-OAIConversation`, `Remove-OAIConversation`
  - GPT Management: `Get-OAIGPT`, `Get-OAIGPTConfiguration`, `Get-OAIGPTFileContent`, `Get-OAIGPTSharedUser`, `Remove-OAIGPT`, `Remove-OAIGPTFile`, `Revoke-OAIGPTAccess`
  - Project Management: `Get-OAIProject`, `Get-OAIProjectConfiguration`, `Get-OAIProjectFileContent`, `Get-OAIProjectSharedUser`, `Remove-OAIProject`, `Remove-OAIProjectFile`, `Revoke-OAIProjectAccess`
  - Memory Management: `Get-OAIMemory`, `Get-OAIUserMemory`, `Remove-OAIUserMemory`
  - Automation Management: `Get-OAIUserAutomation`, `Remove-OAIUserAutomation`
  - Canvas Management: `Get-OAIUserCanvas`, `Get-OAICanvasContent`, `Remove-OAICanvas`
  - Recording Management: `Get-OAIRecording`, `Get-OAIUserRecording`, `Get-OAIUserRecordingTranscript`, `Remove-OAIRecording`, `Remove-OAIUserRecording`
  - Codex Management: `Get-OAICodexTask`, `Get-OAICodexEnvironment`, `Remove-OAICodexTask`, `Remove-OAICodexEnvironment`
  - Initialization: `Initialize-OAICompliance`
- Comprehensive parameter validation and pipeline support
- `ShouldProcess` support for all destructive operations with `-WhatIf` and `-Confirm`
- Built-in debug logging with `-Debug` parameter support
- Automatic pagination handling for list endpoints
- Timestamp filtering for incremental data exports
- Support for file content retrieval via 307 redirects
- Proper URL encoding for query parameters
- Consistent error handling across all cmdlets
- Comprehensive help documentation for all public functions

### Security

- Secure API key handling with masking in debug output
- All API requests logged by OpenAI for audit purposes
- Permanent deletion warnings for all destructive operations

---

## Release Notes

### Beta Release Warning

This is a beta release. There may be bugs, breaking changes, or incomplete functionality. Use with caution in production environments and always test thoroughly before deploying.

### API Coverage

This module provides complete coverage of the OpenAI ChatGPT Enterprise Compliance API v1.1.5 as of August 2025, including all endpoint categories:

- Conversations, Users, GPTs, Projects, Memories, Automations, Canvas, Recordings, Codex Tasks, and Codex Environments

### Requirements

- PowerShell 5.1 or later
- System.Web assembly (for URL encoding)
- ChatGPT Enterprise workspace administrator access
- API key with compliance scopes granted by OpenAI

### Breaking Changes

- N/A (initial release)

[0.0.1]: https://github.com/thetolkienblackguy/OpenAI.Compliance.PowerShell/releases/tag/v0.0.1
