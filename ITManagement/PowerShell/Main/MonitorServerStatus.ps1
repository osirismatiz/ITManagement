<#
    Date       : 2019-03-07
    Author     : Osiris Matiz Zapata
    Name       : ChangeServicePassword
    Description: Change passwords to all services list 
#>

#[CmdletBinding()]
#param ([Parameter(Mandatory=$true)][string]$Environment, [Parameter(Mandatory=$true)][string]$Farm)

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy

[System.GC]::Collect()
Clear-Host

###Import Modules
. ..\Modules\ModuleXML.ps1 
. ..\Modules\ModuleLogs.ps1 
. ..\Modules\ModuleHTML.ps1 
. ..\Modules\ModuleSendEmail.ps1 


$SCRIPTNAME = $MyInvocation.MyCommand.Name
$host.ui.rawui.windowtitle = $SCRIPTNAME
WriteLog "INFO" $SCRIPTNAME $SCRIPTNAME

function Main{
	#param([Parameter(Mandatory=$true)][string]$environmentName, [Parameter(Mandatory=$true)][string]$farmName)
    Try{ 
		$serversList = GetServersList
		
		#$credentials = Get-Credential -Credential "SLPAlRT_LAB2016@ACEINA"

		$computerName = $env:computername
		$arrayServers = @()
		
		foreach ($itemServer in $serversList) { 
			Try{
				WriteLog "INFO" ("Server Name: {0}" -f $itemServer) $SCRIPTNAME

				$PingStatus = Test-Connection -ComputerName $itemServer -Count 1 -Quiet
				$ipAddres = $computerIP = ((Test-Connection -ComputerName $itemServer -count 1).ipv4address.IPAddressToString)
				
				## If server responds, get the stats for the server.
				If ($PingStatus){
					$CpuAlert = $false
					$MemAlert = $false
					$DiskAlert = $false
					$OperatingSystem = Get-WmiObject Win32_OperatingSystem -ComputerName $itemServer
					$CpuUsage = Get-WmiObject Win32_Processor -ComputerName $itemServer | Measure-Object -Property LoadPercentage -Average | ForEach-Object {$_.Average; If($_.Average -ge $CpuAlertThreshold){$CpuAlert = $True};}
					$MemUsage = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $itemServer | ForEach-Object {"{0:N0}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) * 100)/ $_.TotalVisibleMemorySize); If((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) * 100)/ $_.TotalVisibleMemorySize -ge $MemAlertThreshold){$MemAlert = $True};}
					$DiskUsage = Get-WmiObject Win32_LogicalDisk -ComputerName $itemServer | Where-Object {$_.DriveType -eq 3} | Foreach-Object {$_.DeviceID, [Math]::Round((($_.Size - $_.FreeSpace) * 100)/ $_.Size); If([Math]::Round((($_.Size - $_.FreeSpace) * 100)/ $_.Size) -ge $DiskAlertThreshold){$DiskAlert = $True};}
				}
			}
			Catch{
			}
			Finally{
				## Put the results together in an array.		
				$serverObject = New-Object -TypeName PSObject
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'Server Name' -Value $itemServer
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'Server IP' -Value $ipAddres
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'Ping' -Value $PingStatus
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'CpuUsage' -Value $CpuUsage
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'MemUsage' -Value $MemUsage
				Add-Member -InputObject $serverObject -MemberType NoteProperty -Force -Name 'DiskUsage' -Value ($DiskUsage | Out-String)
				$arrayServers += $serverObject 
				
				## Clear the variables after obtaining and storing the results, otherwise data is duplicated.
				If ($PingStatus) { Clear-Variable PingStatus }
				If ($CpuUsage) { Clear-Variable CpuUsage }
				If ($MemUsage) { Clear-Variable MemUsage } 
				If ($DiskUsage) { Clear-Variable DiskUsage }
				Continue
			}
		}
		
		#$arrayServers | Format-Table -AutoSize 
		$computerIP = ((Test-Connection -ComputerName $env:computername -count 1).ipv4address.IPAddressToString)
		$htmlTable = CreateObjectToHtmlTableGreenStyle $arrayServers "Servers Monitor $computerName - [$computerIP]"
		
		# Highlight Status codes
		$htmlTable = $htmlTable -Replace '<td>False</td>', '<td style="background:#FDD;">False</td>'
		$htmlTable = $htmlTable -Replace '<td>401</td>', '<td style="background:#FFC107;">401</td>'
		$htmlTable = $htmlTable -Replace '<td>True</td>', '<td style="background:#DFD;">True</td>'
		
	}
	Catch{ 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[Main] $FailedItem. The error message was $ErrorMessage. ($PSItem.Exception.StackTrace)" $SCRIPTNAME  #-ErrorAction Continue
	}
	Finally{
		#Send Email
			SendMessage `
			"osirismatiz@createglobalweb.com" `
			"monicahidalgo@createglobalweb.com" `
			"Servers Monitor $computerName - [$computerIP]" `
			"$htmlTable"
	}
}


Main 
