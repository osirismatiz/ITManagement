
function CreateObjectToHTML{
	param([Parameter(Mandatory=$true)]$htmlObject,
			[Parameter(Mandatory=$true)][string]$htmlTitle
			)

	Try{
		$web = New-Object Net.WebClient
		# Get bootstrap css
		$bootstrap =  $web.DownloadString("https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css")
		# Get fontawesome css
		$fontawesome = $web.DownloadString("https://use.fontawesome.com/releases/v5.6.1/css/all.css")
			
		$htmlHeader = '<title>{0}</title>' -f $htmlTitle
		
		$htmlHeader += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> '
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += '{0}' -f $bootstrap 
		$htmlHeader += '</style> '
		
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader 

		# table format
		$htmlMessage = $htmlMessage -Replace '<table>', '<div style="width: 90%; font-size: 9px;"><table id="tablePreview" class="table table-responsive-sm table-condensed table-striped table-hover table-bordered w-auto">'
		$htmlMessage = $htmlMessage -replace '<tr><th>', '<thead><tr><th>'
		$htmlMessage = $htmlMessage -replace '</th></tr>', '</th></tr></thead><tbody>'
		$htmlMessage = $htmlMessage -replace '</table>', '</tbody></table></div>'

		Write-Output $htmlMessage 
	}
	Catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[CreateHTMLFromObject] $FailedItem. The error message was $ErrorMessage" $SCRIPTNAME #-ErrorAction Stop
	}
	Finally{
		#Get-Date 
	}
}
