### PowerShell Profile Refactor
### Version 1.03 - Refactored

$debug = $false

# Define the path to the file that stores the last execution time
$timeFilePath = [Environment]::GetFolderPath("MyDocuments") + "\PowerShell\LastExecutionTime.txt"

# Define the update interval in days, set to -1 to always check
$updateInterval = 9999999 # never update

if ($debug) {
    Write-Host "#######################################" -ForegroundColor #BF616A
    Write-Host "#           Debug mode enabled        #" -ForegroundColor #BF616A
    Write-Host "#          ONLY FOR DEVELOPMENT       #" -ForegroundColor #BF616A
    Write-Host "#                                     #" -ForegroundColor #BF616A
    Write-Host "#       IF YOU ARE NOT DEVELOPING     #" -ForegroundColor #BF616A
    Write-Host "#       JUST RUN \`Update-Profile\`   #" -ForegroundColor #BF616A
    Write-Host "#        to discard all changes       #" -ForegroundColor #BF616A
    Write-Host "#   and update to the latest profile  #" -ForegroundColor #BF616A
    Write-Host "#               version               #" -ForegroundColor #BF616A
    Write-Host "#######################################" -ForegroundColor #BF616A
}


#################################################################################################################################
############                                                                                                         ############
############                                          !!!   WARNING:   !!!                                           ############
############                                                                                                         ############
############                DO NOT MODIFY THIS FILE. THIS FILE IS HASHED AND UPDATED AUTOMATICALLY.                  ############
############                    ANY CHANGES MADE TO THIS FILE WILL BE OVERWRITTEN BY COMMITS TO                      ############
############                       https://github.com/ChrisTitusTech/powershell-profile.git.                         ############
############                                                                                                         ############
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
############                                                                                                         ############
############                      IF YOU WANT TO MAKE CHANGES, USE THE Edit-Profile FUNCTION                         ############
############                              AND SAVE YOUR CHANGES IN THE FILE CREATED.                                 ############
############                                                                                                         ############
#################################################################################################################################

#opt-out of telemetry before doing anything, only if PowerShell is run as admin
if ([bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem) {
    [System.Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 'true', [System.EnvironmentVariableTarget]::Machine)
}

# Initial GitHub.com connectivity check with 1 second timeout
$global:canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Check for Profile Updates
# function Update-Profile {
#     try {
#         $url = "https://raw.githubusercontent.com/Aisolon/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
#         $oldhash = Get-FileHash $PROFILE
#         Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
#         $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
#         if ($newhash.Hash -ne $oldhash.Hash) {
#             Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
#             Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor #D08770
#         } else {
#             Write-Host "Profile is up to date." -ForegroundColor #A3BE8C
#         }
#     } catch {
#         Write-Error "Unable to check for `$profile updates: $_"
#     } finally {
#         Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
#     }
# }
#
# # Check if not in debug mode AND (updateInterval is -1 OR file doesn't exist OR time difference is greater than the update interval)
# if (-not $debug -and `
#     ($updateInterval -eq -1 -or `
#       -not (Test-Path $timeFilePath) -or `
#       ((Get-Date) - [datetime]::ParseExact((Get-Content -Path $timeFilePath), 'yyyy-MM-dd', $null)).TotalDays -gt $updateInterval)) {
#
#     Update-Profile
#     $currentTime = Get-Date -Format 'yyyy-MM-dd'
#     $currentTime | Out-File -FilePath $timeFilePath
#
# } elseif ($debug) {
#     Write-Warning "Skipping profile update check in debug mode"
# }
#
# function Update-PowerShell {
#     try {
#         Write-Host "Checking for PowerShell updates..." -ForegroundColor #88C0D0
#         $updateNeeded = $false
#         $currentVersion = $PSVersionTable.PSVersion.ToString()
#         $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
#         $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
#         $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
#         if ($currentVersion -lt $latestVersion) {
#             $updateNeeded = $true
#         }
#
#         if ($updateNeeded) {
#             Write-Host "Updating PowerShell..." -ForegroundColor #EBCB8B
#             Start-Process powershell.exe -ArgumentList "-NoProfile -Command winget upgrade Microsoft.PowerShell --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
#             Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor #D08770
#         } else {
#             Write-Host "Your PowerShell is up to date." -ForegroundColor #A3BE8C
#         }
#     } catch {
#         Write-Error "Failed to update PowerShell. Error: $_"
#     }
# }
#
# # skip in debug mode
# # Check if not in debug mode AND (updateInterval is -1 OR file doesn't exist OR time difference is greater than the update interval)
# if (-not $debug -and `
#     ($updateInterval -eq -1 -or `
#      -not (Test-Path $timeFilePath) -or `
#      ((Get-Date).Date - [datetime]::ParseExact((Get-Content -Path $timeFilePath), 'yyyy-MM-dd', $null).Date).TotalDays -gt $updateInterval)) {
#
#     Update-PowerShell
#     $currentTime = Get-Date -Format 'yyyy-MM-dd'
#     $currentTime | Out-File -FilePath $timeFilePath
# } elseif ($debug) {
#     Write-Warning "Skipping PowerShell update in debug mode"
# }

function Clear-Cache {
    # add clear cache logic here
    Write-Host "Clearing cache..." -ForegroundColor #88C0D0

    # Clear Windows Prefetch
    Write-Host "Clearing Windows Prefetch..." -ForegroundColor #EBCB8B
    Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

    # Clear Windows Temp
    Write-Host "Clearing Windows Temp..." -ForegroundColor #EBCB8B
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear User Temp
    Write-Host "Clearing User Temp..." -ForegroundColor #EBCB8B
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear Internet Explorer Cache
    Write-Host "Clearing Internet Explorer Cache..." -ForegroundColor #EBCB8B
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Cache clearing completed." -ForegroundColor #A3BE8C
}

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt {
    if ($isAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}
$adminSuffix = if ($isAdmin) { " [ADMIN]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configuration
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
          elseif (Test-CommandExists pvim) { 'pvim' }
          elseif (Test-CommandExists vim) { 'vim' }
          elseif (Test-CommandExists vi) { 'vi' }
          elseif (Test-CommandExists code) { 'code' }
          elseif (Test-CommandExists notepad++) { 'notepad++' }
          elseif (Test-CommandExists sublime_text) { 'sublime_text' }
          else { 'notepad' }
Set-Alias -Name vim -Value $EDITOR

# Quick Access to Editing the Profile
function Edit-Profile {
    vim $PROFILE.CurrentUserAllHosts
}
Set-Alias -Name ep -Value Edit-Profile

function touch($file) { "" | Out-File $file -Encoding ASCII }
function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.FullName)"
    }
}

# Network Utilities
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# Open WinUtil full-release
# function winutil {
# 	irm https://christitus.com/win | iex
# }
#
# # Open WinUtil pre-release
# function winutildev {
# 	irm https://christitus.com/windev | iex
# }

# System Utilities
function admin {
    if ($args.Count -gt 0) {
        $argList = $args -join ' '
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    } else {
        Start-Process wt -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights.
Set-Alias -Name su -Value admin

function uptime {
    try {
        # find date/time format
        $dateFormat = [System.Globalization.CultureInfo]::CurrentCulture.DateTimeFormat.ShortDatePattern
        $timeFormat = [System.Globalization.CultureInfo]::CurrentCulture.DateTimeFormat.LongTimePattern
		
        # check powershell version
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $lastBoot = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $bootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBoot)

            # reformat lastBoot
            $lastBoot = $bootTime.ToString("$dateFormat $timeFormat")
        } else {
            $lastBoot = net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
            $bootTime = [System.DateTime]::ParseExact($lastBoot, "$dateFormat $timeFormat", [System.Globalization.CultureInfo]::InvariantCulture)
        }

        # Format the start time
        $formattedBootTime = $bootTime.ToString("dddd, MMMM dd, yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture) + " [$lastBoot]"
        Write-Host "System started on: $formattedBootTime" -ForegroundColor #4C566A 

        # calculate uptime
        $uptime = (Get-Date) - $bootTime

        # Uptime in days, hours, minutes, and seconds
        $days = $uptime.Days
        $hours = $uptime.Hours
        $minutes = $uptime.Minutes
        $seconds = $uptime.Seconds

        # Uptime output
        Write-Host ("Uptime: {0} days, {1} hours, {2} minutes, {3} seconds" -f $days, $hours, $minutes, $seconds) -ForegroundColor #5E81AC 

    } catch {
        Write-Error "An error occurred while retrieving system uptime."
    }
}

function reload-profile {
    & $profile
}

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function hb {
    if ($args.Length -eq 0) {
        Write-Error "No file path specified."
        return
    }
    
    $FilePath = $args[0]
    
    if (Test-Path $FilePath) {
        $Content = Get-Content $FilePath -Raw
    } else {
        Write-Error "File path does not exist."
        return
    }
    
    $uri = "http://bin.christitus.com/documents"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $Content -ErrorAction Stop
        $hasteKey = $response.key
        $url = "http://bin.christitus.com/$hasteKey"
	    Set-Clipboard $url
        Write-Output "$url copied to clipboard."
    } catch {
        Write-Error "Failed to upload the document. Error: $_"
    }
}
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function df {
    get-volume
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10, [switch]$f = $false)
  Get-Content $Path -Tail $n -Wait:$f
}

# Quick File Creation
function nf { param($name) New-Item -ItemType "file" -Path . -Name $name }

# Directory Management
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }

function trash($path) {
    $fullPath = (Resolve-Path -Path $path).Path

    if (Test-Path $fullPath) {
        $item = Get-Item $fullPath

        if ($item.PSIsContainer) {
          # Handle directory
            $parentPath = $item.Parent.FullName
        } else {
            # Handle file
            $parentPath = $item.DirectoryName
        }

        $shell = New-Object -ComObject 'Shell.Application'
        $shellItem = $shell.NameSpace($parentPath).ParseName($item.Name)

        if ($item) {
            $shellItem.InvokeVerb('delete')
            Write-Host "Item '$fullPath' has been moved to the Recycle Bin."
        } else {
            Write-Host "Error: Could not find the item '$fullPath' to trash."
        }
    } else {
        Write-Host "Error: Item '$fullPath' does not exist."
    }
}

### Quality of Life Aliases

# Navigation Shortcuts
# function docs { 
#     $docs = if(([Environment]::GetFolderPath("MyDocuments"))) {([Environment]::GetFolderPath("MyDocuments"))} else {$HOME + "\Documents"}
#     Set-Location -Path $docs
# }
#     
# function dtop { 
#     $dtop = if ([Environment]::GetFolderPath("Desktop")) {[Environment]::GetFolderPath("Desktop")} else {$HOME + "\Documents"}
#     Set-Location -Path $dtop
# }

# Simplified Process Management
function k9 { Stop-Process -Name $args[0] }

# Enhanced Listing
function la { Get-ChildItem | Format-Table -AutoSize }
function ll { Get-ChildItem -Force | Format-Table -AutoSize }

# Git Shortcuts
function gs { git status }

function ga { git add . }

function gc { param($m) git commit -m "$m" }

function gpush { git push }

function gpull { git pull }

function g { __zoxide_z github }

function gcl { git clone "$args" }

function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}

# Quick Access to System Information
function sysinfo { Get-ComputerInfo }

# Networking Utilities
function flushdns {
	Clear-DnsClientCache
	Write-Host "DNS has been flushed"
}

# Clipboard Utilities
function cpy { Set-Clipboard $args[0] }

function pst { Get-Clipboard }

# Enhanced PowerShell Experience
# Enhanced PSReadLine Configuration
$PSReadLineOptions = @{
    EditMode = 'Windows'
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        Command = '#81A1C1'  # SkyBlue (pastel)
        Parameter = '#A3BE8C'  # PaleGreen (pastel)
        Operator = '#D08770'  # LightPink (pastel)
        Variable = '#B48EAD'  # Plum (pastel)
        String = '#EBCB8B'  # PeachPuff (pastel)
        Number = '#8FBCBB'  # PowderBlue (pastel)
        Type = '#EBCB8B'  # Khaki (pastel)
        Comment = '#D8DEE9'  # LightGray (pastel)
        Keyword = '#B48EAD'  # Violet (pastel)
        Error = '#BF616A'  # Tomato (keeping it close to red for visibility)
    }
    PredictionSource = 'History'
    PredictionViewStyle = 'ListView'
    BellStyle = 'None'
}
Set-PSReadLineOption @PSReadLineOptions

# Custom key handlers
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo

# Custom functions for PSReadLine
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)
    $sensitive = @('password', 'secret', 'token', 'apikey', 'connectionstring')
    $hasSensitive = $sensitive | Where-Object { $line -match $_ }
    return ($null -eq $hasSensitive)
}

# Improved prediction settings
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -MaximumHistoryCount 10000

# Custom completion for common commands
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $customCompletions = @{
        'git' = @('status', 'add', 'commit', 'push', 'pull', 'clone', 'checkout')
        'npm' = @('install', 'start', 'run', 'test', 'build')
        'deno' = @('run', 'compile', 'bundle', 'test', 'lint', 'fmt', 'cache', 'info', 'doc', 'upgrade')
    }
    
    $command = $commandAst.CommandElements[0].Value
    if ($customCompletions.ContainsKey($command)) {
        $customCompletions[$command] | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}
Register-ArgumentCompleter -Native -CommandName git, npm, deno -ScriptBlock $scriptblock

$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $scriptblock


# Get theme from profile.ps1 or use a default theme
# function Get-Theme {
#     if (Test-Path -Path $PROFILE.CurrentUserAllHosts -PathType leaf) {
#         $existingTheme = Select-String -Raw -Path $PROFILE.CurrentUserAllHosts -Pattern "oh-my-posh init pwsh --config"
#         if ($null -ne $existingTheme) {
#             Invoke-Expression $existingTheme
#             return
#         }
#         oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
#     } else {
#         oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
#     }
# }
function Get-Theme {
    $existingTheme = Select-String -Raw -Path $PROFILE.CurrentUserAllHosts -Pattern "oh-my-posh init pwsh --config"
        if ($null -ne $existingTheme) {
            Invoke-Expression $existingTheme
            return
        }
}

## Final Line to set prompt
Get-Theme
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    } catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}

Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force

# Help Function
function Show-Help {
    $helpText = @"
$($PSStyle.Foreground.FromRgb(136, 192, 208))PowerShell Profile Help$($PSStyle.Reset)
$($PSStyle.Foreground.FromRgb(235, 203, 139))=======================$($PSStyle.Reset)

$($PSStyle.Foreground.FromRgb(163, 190, 140))Update-Profile$($PSStyle.Reset) - Checks for profile updates from a remote repository and updates if necessary.

$($PSStyle.Foreground.FromRgb(163, 190, 140))Update-PowerShell$($PSStyle.Reset) - Checks for the latest PowerShell release and updates if a new version is available.

$($PSStyle.Foreground.FromRgb(163, 190, 140))Edit-Profile$($PSStyle.Reset) - Opens the current user's profile for editing using the configured editor.

$($PSStyle.Foreground.FromRgb(163, 190, 140))touch$($PSStyle.Reset) <file> - Creates a new empty file.

$($PSStyle.Foreground.FromRgb(163, 190, 140))ff$($PSStyle.Reset) <name> - Finds files recursively with the specified name.

$($PSStyle.Foreground.FromRgb(163, 190, 140))Get-PubIP$($PSStyle.Reset) - Retrieves the public IP address of the machine.

$($PSStyle.Foreground.FromRgb(163, 190, 140))winutil$($PSStyle.Reset) - Runs the latest WinUtil full-release script from Chris Titus Tech.

$($PSStyle.Foreground.FromRgb(163, 190, 140))winutildev$($PSStyle.Reset) - Runs the latest WinUtil pre-release script from Chris Titus Tech.

$($PSStyle.Foreground.FromRgb(163, 190, 140))uptime$($PSStyle.Reset) - Displays the system uptime.

$($PSStyle.Foreground.FromRgb(163, 190, 140))reload-profile$($PSStyle.Reset) - Reloads the current user's PowerShell profile.

$($PSStyle.Foreground.FromRgb(163, 190, 140))unzip$($PSStyle.Reset) <file> - Extracts a zip file to the current directory.

$($PSStyle.Foreground.FromRgb(163, 190, 140))hb$($PSStyle.Reset) <file> - Uploads the specified file's content to a hastebin-like service and returns the URL.

$($PSStyle.Foreground.FromRgb(163, 190, 140))grep$($PSStyle.Reset) <regex> [dir] - Searches for a regex pattern in files within the specified directory or from the pipeline input.

$($PSStyle.Foreground.FromRgb(163, 190, 140))df$($PSStyle.Reset) - Displays information about volumes.

$($PSStyle.Foreground.FromRgb(163, 190, 140))sed$($PSStyle.Reset) <file> <find> <replace> - Replaces text in a file.

$($PSStyle.Foreground.FromRgb(163, 190, 140))which$($PSStyle.Reset) <name> - Shows the path of the command.

$($PSStyle.Foreground.FromRgb(163, 190, 140))export$($PSStyle.Reset) <name> <value> - Sets an environment variable.

$($PSStyle.Foreground.FromRgb(163, 190, 140))pkill$($PSStyle.Reset) <name> - Kills processes by name.

$($PSStyle.Foreground.FromRgb(163, 190, 140))pgrep$($PSStyle.Reset) <name> - Lists processes by name.

$($PSStyle.Foreground.FromRgb(163, 190, 140))head$($PSStyle.Reset) <path> [n] - Displays the first n lines of a file (default 10).

$($PSStyle.Foreground.FromRgb(163, 190, 140))tail$($PSStyle.Reset) <path> [n] - Displays the last n lines of a file (default 10).

$($PSStyle.Foreground.FromRgb(163, 190, 140))nf$($PSStyle.Reset) <name> - Creates a new file with the specified name.

$($PSStyle.Foreground.FromRgb(163, 190, 140))mkcd$($PSStyle.Reset) <dir> - Creates and changes to a new directory.

$($PSStyle.Foreground.FromRgb(163, 190, 140))docs$($PSStyle.Reset) - Changes the current directory to the user's Documents folder.

$($PSStyle.Foreground.FromRgb(163, 190, 140))dtop$($PSStyle.Reset) - Changes the current directory to the user's Desktop folder.

$($PSStyle.Foreground.FromRgb(163, 190, 140))ep$($PSStyle.Reset) - Opens the profile for editing.

$($PSStyle.Foreground.FromRgb(163, 190, 140))k9$($PSStyle.Reset) <name> - Kills a process by name.

$($PSStyle.Foreground.FromRgb(163, 190, 140))la$($PSStyle.Reset) - Lists all files in the current directory with detailed formatting.

$($PSStyle.Foreground.FromRgb(163, 190, 140))ll$($PSStyle.Reset) - Lists all files, including hidden, in the current directory with detailed formatting.

$($PSStyle.Foreground.FromRgb(163, 190, 140))gs$($PSStyle.Reset) - Shortcut for 'git status'.

$($PSStyle.Foreground.FromRgb(163, 190, 140))ga$($PSStyle.Reset) - Shortcut for 'git add .'.

$($PSStyle.Foreground.FromRgb(163, 190, 140))gc$($PSStyle.Reset) <message> - Shortcut for 'git commit -m'.

$($PSStyle.Foreground.FromRgb(163, 190, 140))gp$($PSStyle.Reset) - Shortcut for 'git push'.

$($PSStyle.Foreground.FromRgb(163, 190, 140))g$($PSStyle.Reset) - Changes to the GitHub directory.

$($PSStyle.Foreground.FromRgb(163, 190, 140))gcom$($PSStyle.Reset) <message> - Adds all changes and commits with the specified message.

$($PSStyle.Foreground.FromRgb(163, 190, 140))lazyg$($PSStyle.Reset) <message> - Adds all changes, commits with the specified message, and pushes to the remote repository.

$($PSStyle.Foreground.FromRgb(163, 190, 140))sysinfo$($PSStyle.Reset) - Displays detailed system information.

$($PSStyle.Foreground.FromRgb(163, 190, 140))flushdns$($PSStyle.Reset) - Clears the DNS cache.

$($PSStyle.Foreground.FromRgb(163, 190, 140))cpy$($PSStyle.Reset) <text> - Copies the specified text to the clipboard.

$($PSStyle.Foreground.FromRgb(163, 190, 140))pst$($PSStyle.Reset) - Retrieves text from the clipboard.

Use '$($PSStyle.Foreground.FromRgb(208, 135, 112))Show-Help$($PSStyle.Reset)' to display this help message.
"@
    Write-Host $helpText
}

# if (Test-Path "$PSScriptRoot\CTTcustom.ps1") {
#     Invoke-Expression -Command "& `"$PSScriptRoot\CTTcustom.ps1`""
# }

# Write-Host "$($PSStyle.Foreground.FromRgb(235, 203, 139))Use 'Show-Help' to display help$($PSStyle.Reset)"
