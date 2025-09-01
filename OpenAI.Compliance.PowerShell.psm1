
# Set default parameters
$PSDefaultParameterValues["Get-ChildItem:File"] = $true
$PSDefaultParameterValues["Join-Path:Path"] = $PSScriptRoot

# Import all classes, private functions, and public functions
$imports = @("Classes\Composites", "Classes\Components", "Public")
$class_types = @{}
Foreach ($import in $imports) {
    # Get the path to the import folder
    $path = Join-Path -ChildPath "$($import)" 

    # Get-ChildItem parameters
    $get_child_params = @{}
    $get_child_params["Path"] = $path   
    $get_child_params["File"] = $true
    $get_child_params["Recurse"] = $true
    $get_child_params["Include"] = "*.ps1"
    
    # Get all the files in the import folder
    $files = Get-ChildItem @get_child_params

    # Dot source all the files
    Foreach ($file in $files) {
        . $file.FullName

        # Export public functions
        If ($import -eq "Public") {
            Export-ModuleMember -Function $file.BaseName
        
        }
        If ($import -match "Classes") {
            $class_types[$file.BaseName] = $file.FullName
        
        }
    }
}

# Add class types as accelerators
$type_accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')

# Check each discovered class to see if it's now defined
foreach ($class_name in $class_types.Keys) {
    # Try to get the actual Type object
    $type = $null
    try {
        # This will evaluate the type name into a Type object if it exists
        $type = Invoke-Expression "[type]'$class_name'"
    
    } catch {
        Write-Verbose "Could not find type for class: $className"
        continue
    }
    
    if ($type -is [type]) {
        try {
            # Register it as a type accelerator
            $type_accelerators::Add($class_name, $type)

            Write-Verbose "Registered type accelerator for: $class_name"
        } catch {
            # Type accelerator might already exist
            Write-Verbose "Could not register type accelerator for: $class_name. It may already exist."
        
        }
    }
}