foreach ($file in Get-ChildItem -Path "C:\users\" -Filter "d*" -Directory |  Get-ChildItem -File -Recurse | %{$_.FullName}) {remove-item -force $file}
