#Author: Sandro Pereira
#Date: 2016-02-14

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Get-ExecutionPolicy

[System.GC]::Collect()
Clear-Host

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$host.ui.rawui.windowtitle = $SCRIPTNAME

###Import Modules
. ..\Modules\ModuleXML.ps1 
. ..\Modules\ModuleLogs.ps1 
. ..\Modules\ModuleHTML.ps1 
. ..\Modules\ModuleSendEmail.ps1 

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$host.ui.rawui.windowtitle = $SCRIPTNAME
WriteLog "INFO" $SCRIPTNAME $SCRIPTNAME

function Main{
	Try{ 
		WriteLog "INFO" ("Reading HostInstances..." ) $SCRIPTNAME
		#Get DB info
		[string]$SQLInstance = Get-WmiObject MSBTS_GroupSetting -namespace root\MicrosoftBizTalkServer | Select-Object -expand MgmtDbServerName
		[string]$BizTalkManagementDb = Get-WmiObject MSBTS_GroupSetting -namespace root\MicrosoftBizTalkServer | Select-Object -expand MgmtDbName
		[string]$BizTalkGroup = "$SQLInstance" + ":" + "$BizTalkManagementDb"

		# Get Host instances not running
		[array]$hostInstances = Get-WmiObject MSBTS_HostInstance  -namespace 'root\MicrosoftBizTalkServer' -filter '(HostType = 1 and ServiceState != 4)'

		#Cancel if all host instances are running
		if ($hostInstances -eq $null) { Exit }

		$arrayHosts = @()

		foreach ($hostInstance in $hostInstances)
		{
			# Stopped: 1
			# Start pending: 2
			# Stop pending: 3
			# Running: 4
			# Continue pending: 5
			# Pause pending: 6
			# Paused: 7
			# Unknown: 8

			$statusHI = ''
			switch ($hostInstance.ServiceState)
			{
				1 { $statusHI = 'Stopped' }
				2 { $statusHI = 'Start pending' }
				3 { $statusHI = 'Stop pending' }
				5 { $statusHI = 'Continue pending' }
				6 { $statusHI = 'Pause pending' }
				7 { $statusHI = 'Paused' }
				8 { $statusHI = 'Unknown' }
			}

			#0: UnClusteredInstance
			#1: ClusteredInstance
			#2: ClusteredVirtualInstance
			
			$ClusteredInstance = ''
			switch ($hostInstance.ClusterInstanceType)
			{
				0 { $ClusteredInstance = 'UnClustered Instance' }
				1 { $ClusteredInstance = 'Clustered Instance' }
				2 { $ClusteredInstance = 'Clustered Virtual Instance' }
			}
			
			$itWasStarted = ''
			#Auto-Healing feature
			if ($hostInstance.IsDisabled -ne 'True')
			{
				WriteLog "INFO" ("Starting HostInstance {0}..." -f $hostInstance.HostName) $SCRIPTNAME
				Try{
					$hostInstance.InvokeMethod("Start", $null)
					$itWasStarted = 'Yes'
				}
				Catch{
					$itWasStarted = 'No'
					$ErrorMessage = $_.Exception.Message
					$FailedItem = $_.Exception.ItemName
					WriteLog "ERROR" "[Main InvokeMethod] $FailedItem. The error message was $ErrorMessage" $SCRIPTNAME -ErrorAction Continue
				}
			}
			
			$isDisabled = $(if ($hostInstance.IsDisabled -eq 'True') { $hostInstance.IsDisabled } else { '' }) 
			$hostObject = New-Object -TypeName PSObject
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Host Name' -Value $hostInstance.HostName
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Host Type' -Value 'In-process'
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Running Server' -Value $hostInstance.RunningServer
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Cluster Instance Type' -Value $ClusteredInstance
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'NT Group Name' -Value $hostInstance.NTGroupName
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Logon' -Value $hostInstance.Logon
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Is Disabled' -Value $isDisabled
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Service State' -Value $statusHI
			Add-Member -InputObject $hostObject -MemberType NoteProperty -Force -Name 'Autostarted' -Value $itWasStarted
			$arrayHosts += $hostObject
		}
		
		$computerName = $env:computername
		$computerIP = ((Test-Connection -ComputerName $env:computername -count 1).ipv4address.IPAddressToString)
		#$arrayHosts | Format-Table -AutoSize 
		$htmlTable = CreateObjectToHtmlTableGreenStyle $arrayHosts "BizTalk HostInstances Monitor $computerName - [$computerIP]"
		#$htmlTable | Out-File -FilePath '.\report.html' -Force 
		
		# Highlight Status
		$htmlTable = $htmlTable -Replace '<td>Stopped</td>', '<td style="background:#FDD;">Stopped</td>'
		$htmlTable = $htmlTable -Replace '<td>Yes</td>', '<td style="background:#DFD;">Yes</td>'
		$htmlTable = $htmlTable -Replace '<td>No</td>', '<td style="background:#FDD;">No</td>'
	}
	Catch{ 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[Main] $FailedItem. The error message was $ErrorMessage. ($PSItem.Exception.StackTrace)" $SCRIPTNAME
	}
	Finally{
		#Send Email
		if ($hostInstances -ne $null){
			SendMessageNoSSL `
			"noreply@chubb.com" `
			"osiris.matiz2@chubb.com" `
			"BizTalk HostInstances Monitor $computerName - [$computerIP]" `
			"$htmlTable"
		}
	}
}

Main 
