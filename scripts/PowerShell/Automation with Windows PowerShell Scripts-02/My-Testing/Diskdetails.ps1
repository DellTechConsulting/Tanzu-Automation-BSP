#Get DISK usage information and export it to a CSV file for trend reporting
Param(
	[string[]]$Computername = $env:COMPUTERNAME
)
		
#Path to CSV file is hard coded in this case.
$csv = "C:\Users\bhavanishankar_pradh\OneDrive - Dell Technologies\DELL-Project-Data\Scripts\PowerShell\Automation with Windows PowerShell Scripts-02\My-Testing\diskhistory.csv"
		
#Initialize an empty array.
$data = @()
		
#Define a hashtable of parameters to splat to Get-CimInstance.
$CimParams = @{
	Classname   = "Win32_LogicalDisk"
	Filter      = "drivetype = 3"
	ErrorAction = "Stop"
}
		
Write-Host "Getting disk information from $Computername" - ForegroundColor Cyan
foreach ($computer in $computername) {
	Write-Host "Getting disk information from $computer." - ForegroundColor Cyan
	#Update the Hashtable on the fly.
	$CimParams.Computername = $CimParams
	Try {
		$disks = Get-CimInstance @cimparams
			
		$data += $disks | 
			Select-Object @{Name = "Computername"; Expression = {$_.SystemName}},
		DeviceID, Size, Freespace,
		@{Name = "PctFree"; Expression = { ($_.Freespace / $_.Size) * 100}},
		@{Name = "Date"; Expression = {Get-Date}}
	} #try
	Catch {
		Write-Warning "Failed to get DISK data from $($computer.toUpper()). $($_.Exception.message)"
	} #catch
} #foreach
		
#Only export if there is something in $data
if ($data) {
	$data | Export-Csv -Path $csv -Append -NoTypeInformation
	Write-Host "Disk report complete. See $CSV." -ForegroundColor Green
}
else {
	Write-Host "No disk data found." -ForegroundColor Yellow
}
		
#Sample usage
# .\GetDiskHistory.ps1 -Computername DC01,W10316N2X2,XYZ,Srv1,Srv2