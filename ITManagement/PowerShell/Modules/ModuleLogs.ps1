$Logfile = "..\Logs\$(gc env:computername).log"

function WriteLog{
	[CmdletBinding()]
	param([Parameter(Mandatory=$False)][ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")][String]$Level = "INFO",
			[Parameter(Mandatory=$True)]$Message,
			[Parameter(Mandatory=$False)][string]$scriptname)

	$timeStamp = (Get-Date).toString("yyyy-MM-dd HH:mm:ss:fff")
    $Line = "$timeStamp [$Level] $scriptname $Message"
	
	try{
        Add-Content $Logfile -Value $Line -Force
	}
	catch{ 
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		Write-Host "[WriteLog] $FailedItem. The error message was $ErrorMessage" -Fore Red
	}
	
	switch ($Level) { 
		'ERROR' { Write-Error "$Message" } 
		'WARN' { Write-Warning "$Message" } 
		'INFO' { Write-Host ("$Message") -Fore Cyan } 
		} 
}
