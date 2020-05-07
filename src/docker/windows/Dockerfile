# escape=`

FROM mcr.microsoft.com/powershell:6.2.0-windowsservercore-1809

ARG agentversion=2.155.1
ENV agentversion=${agentversion}

SHELL [ "pwsh", "-NoProfile", "-Command" ]

WORKDIR /agent

COPY [ "DnsFix.ps1", "./DnsFix.ps1" ]

RUN $ProgressPreference = 'SilentlyContinue' ; `
    Invoke-WebRequest -Uri "https://vstsagentpackage.azureedge.net/agent/$env:agentversion/vsts-agent-win-x64-$env:agentversion.zip" -OutFile "./vsts-agent-win-x64-$env:agentversion.zip" -UseBasicParsing ; `
    Expand-Archive -Path "./vsts-agent-win-x64-$env:agentversion.zip" -DestinationPath . ; `
    Remove-Item "./vsts-agent-win-x64-$env:agentversion.zip" ; `
    New-Item -ItemType Directory -Name Modules -Path c:\ -Force ; `
    Save-Module Az -Path c:\Modules ; `
    Save-Module Pester -Path c:\Modules ; `
    Save-Module PSScriptAnalyzer -Path c:\Modules ; `
    Invoke-WebRequest -Uri https://download.visualstudio.microsoft.com/download/pr/3c43f486-2799-4454-851c-fa7a9fb73633/673099a9fe6f1cac62dd68da37ddbc1a/dotnet-sdk-2.2.203-win-x64.exe -OutFile ./dotnet-sdk-2.2.203-win-x64.exe ; `
    Start-Process ./dotnet-sdk-2.2.203-win-x64.exe -ArgumentList '-q' -Wait ; `
    Remove-Item ./dotnet-sdk-2.2.203-win-x64.exe ; `
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe -OutFile ./Git-2.21.0-64-bit.exe ; `
    Start-Process ./Git-2.21.0-64-bit.exe -ArgumentList ' /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /NOCANCEL /SP-' -Wait ; `
    Remove-Item ./Git-2.21.0-64-bit.exe ; `
    $machinePath = [environment]::GetEnvironmentVariable('path', [System.EnvironmentVariableTarget]::Machine) ; `
    $newMachinePath = 'C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\bin;' + $machinePath ; `
    [environment]::SetEnvironmentVariable('path', $newMachinePath, [System.EnvironmentVariableTarget]::Machine) ; `
    $config = cat $PSHOME/powershell.config.json | ConvertFrom-Json -AsHashtable ; `
    $config.Add('PSModulePath','%ProgramFiles%\PowerShell\Modules;%ProgramFiles%\powershell\latest\Modules;%windir%\system32\WindowsPowerShell\v1.0\Modules;C:\Modules') ; `
    $config | ConvertTo-Json | Out-File $PSHOME/powershell.config.json -Force ; `
    $machineV5ModPath = [environment]::GetEnvironmentVariable('PSModulePath', [System.EnvironmentVariableTarget]::Machine) ; `
    $newMachineV5ModPath = 'c:\Modules;' + $machineV5ModPath ; `
    [environment]::SetEnvironmentVariable('PSModulePath', $newMachineV5ModPath, [System.EnvironmentVariableTarget]::Machine)

ENTRYPOINT [ "C:\\Windows\\system32\\cmd.exe", "/C", "pwsh -f .\\DnsFix.ps1 -nol -noni -nop && .\\config.cmd --unattended --replace && .\\run.cmd" ]