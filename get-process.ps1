try{
Get-Process -name xyz -ErrorAction Stop
}
catch{
Write-Host "oops"
}
