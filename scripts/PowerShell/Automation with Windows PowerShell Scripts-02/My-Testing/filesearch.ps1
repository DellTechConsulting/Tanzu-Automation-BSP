$drv = read-host "c:"
$fname = read-host "Workflow.Targets"
$req = dir -Path $drv -r | Where-Object { !$PsIsContainer -and  [System.IO.Path]::GetFileNameWithoutExtension($_.Name) -eq $fname }
set-location $req.directory
npp $req