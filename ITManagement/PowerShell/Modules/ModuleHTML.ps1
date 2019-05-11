
function CreateObjectToHtmlTableBlueStyle{
	param([Parameter(Mandatory=$true)]$htmlObject, [Parameter(Mandatory=$true)][string]$htmlTitle)

	Try{
		$htmlHeader = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
		$htmlHeader += '<title>{0}</title> ' -f $htmlTitle
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += 'table.blueTable { font-family: Verdana, Geneva, sans-serif; border: 1px solid #1C6EA4; background-color: #EEEEEE; width: 100%; height: 100%; text-align: left; border-collapse: collapse; } '
		$htmlHeader += 'table.blueTable td, table.blueTable th { border: 1px solid #AAAAAA; padding: 3px 2px; } '
		$htmlHeader += 'table.blueTable tbody td { font-size: 12px; color: #333333; } '
		$htmlHeader += 'table.blueTable tr:nth-child(even) { background: #D0E4F5; } '
		$htmlHeader += 'table.blueTable thead { background: #1C6EA4; background: -moz-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%); background: -webkit-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%); background: linear-gradient(to bottom, #5592bb 0%, #327cad 66%, #1C6EA4 100%); border-bottom: 2px solid #444444; } '
		$htmlHeader += 'table.blueTable thead th { font-size: 14px; font-weight: bold; color: #FFFFFF; border-left: 2px solid #D0E4F5; } '
		$htmlHeader += 'table.blueTable thead th:first-child { border-left: none; } '
		$htmlHeader += 'table.blueTable tfoot td { font-size: 14px; } '
		$htmlHeader += 'table.blueTable tfoot .links { text-align: right; } '
		$htmlHeader += 'table.blueTable tfoot .links a{ display: inline-block; background: #1C6EA4; color: #FFFFFF; padding: 2px 8px; border-radius: 5px; } '
		$htmlHeader += '</style> '
		
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader 

		# Table blue style format
		$htmlMessage = $htmlMessage -Replace '<table>', '<div style="width: 90%;"><table class="blueTable">'
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

function CreateObjectToHtmlTableGreenStyle{
	param([Parameter(Mandatory=$true)]$htmlObject, [Parameter(Mandatory=$true)][string]$htmlTitle)

	Try{
		$htmlHeader = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
		$htmlHeader += '<title>{0}</title> ' -f $htmlTitle
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += '*{ box-sizing: border-box; -webkit-box-sizing: border-box; -moz-box-sizing: border-box; } body{ font-family: Helvetica; -webkit-font-smoothing: antialiased;  } h2{ text-align: left; font-size: 18px; text-transform: uppercase; letter-spacing: 1px; color: black; padding: 30px 0; }  /* Table Styles */  .table-wrapper{ margin: 10px; box-shadow: 0px 35px 50px rgba( 0, 0, 0, 0.2 ); }  .fl-table { border-radius: 5px; font-size: 12px; font-weight: normal; border: none; border-collapse: collapse; width: 100%; max-width: 100%; white-space: nowrap; background-color: white; } .fl-table td { text-align: left; padding: 2px; } .fl-table th { text-align: center; padding: 2px; }  .fl-table td { border: 1px solid #f8f8f8; font-size: 12px; }  .fl-table thead th { color: #ffffff; background: #1d96b2; }   .fl-table thead th:nth-child(odd) { color: #ffffff; background: #324960; }  .fl-table tr:nth-child(even) { background: #F8F8F8; }  /* Responsive */  @media (max-width: 767px) { .fl-table { display: block; width: 100%; } .table-wrapper:before{ content: "Scroll horizontally >"; display: block; text-align: right; font-size: 11px; color: white; padding: 0 0 10px; } .fl-table thead, .fl-table tbody, .fl-table thead th { display: block; } .fl-table thead th:last-child{ border-bottom: none; } .fl-table thead { float: left; } .fl-table tbody { width: auto; position: relative; overflow-x: auto; } .fl-table td, .fl-table th { padding: 20px .625em .625em .625em; height: 60px; vertical-align: middle; box-sizing: border-box; overflow-x: hidden; overflow-y: auto; width: 120px; font-size: 13px; text-overflow: ellipsis; } .fl-table thead th { text-align: left; border-bottom: 1px solid #f7f7f9; border-top: 1px solid #f7f7f9; } .fl-table tbody tr { display: table-cell; } .fl-table tbody tr:nth-child(odd) { background: none; } .fl-table tr:nth-child(even) { background: transparent; } .fl-table tr td:nth-child(odd) { background: #F8F8F8; border: 1px solid #E6E4E4; } .fl-table tr td:nth-child(even) { border: 1px solid #E6E4E4; } .fl-table tbody td { display: block; text-align: left; } }'
		$htmlHeader += '</style> '
		
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader -Pre ('<h2>{0}</h2>' -f $htmlTitle) -Pos '<p style="font-size: 8px;">This report is generated automatically by Infrastructure Team. For more details, contact infrastructure Team: ChubbLatinamericaLA_WEBAPP_eMail@Chubb.com</p>'

		# Table blue style format
		$htmlMessage = $htmlMessage -Replace '<table>', '<div class="table-wrapper"><table class="fl-table">'
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

function CreateObjectToHtmlTableBoostrapStyle{
	param([Parameter(Mandatory=$true)]$htmlObject, [Parameter(Mandatory=$true)][string]$htmlTitle)

	Try{
		$htmlHeader = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
		$htmlHeader += '<title>{0}</title> ' -f $htmlTitle
		$htmlHeader += '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css" /> '
		$htmlHeader += '<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.1/css/all.css" />'
				
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader 

		# Table Boostrap Style format
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

function CreateObjectToHtmlTableEmbeddedBoostrapStyle{
	param([Parameter(Mandatory=$true)]$htmlObject, [Parameter(Mandatory=$true)][string]$htmlTitle)

	Try{
		
		$web = New-Object Net.WebClient
		# Get bootstrap css
		$bootstrap =  $web.DownloadString("https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css")
		# Get fontawesome css
		$fontawesome = $web.DownloadString("https://use.fontawesome.com/releases/v5.6.1/css/all.css")
			
		$htmlHeader = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
		$htmlHeader += '<title>{0}</title> ' -f $htmlTitle
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += '{0}' -f $bootstrap 
		$htmlHeader += '</style> '
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += '{0}' -f $fontawesome 
		$htmlHeader += '</style> '
		
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader 

		# Table Boostrap Style format
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

function CreateObjectToHtmlTableParams{
	param([Parameter(Mandatory=$true)]$htmlObject,
			[Parameter(Mandatory=$true)][string]$htmlTitle, 
			[Parameter(Mandatory=$false)][string]$htmlPreContent, 
			[Parameter(Mandatory=$false)][string]$htmlBody, 
			[Parameter(Mandatory=$false)][string]$htmlPostContent
			)

	Try{
		$htmlHeader = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
		$htmlHeader += '<title>{0}</title> ' -f $htmlTitle
		$htmlHeader += '<style type="text/css"> '
		$htmlHeader += 'table { font-family: Verdana, Geneva, sans-serif; border: 1px solid #1C6EA4; background-color: #EEEEEE; width: 100%; height: 100%; text-align: left; border-collapse: collapse; } '
		$htmlHeader += '</style> '
		
		$htmlMessage = $htmlObject | ConvertTo-Html -Head $htmlHeader -PreContent $htmlPreContent -Body $htmlBody -PostContent $htmlPostContent 
		
		# table Boostrap format
		$htmlMessage = $htmlMessage -Replace '<table>', '<div style="width: 90%; font-size: 9px;"><table id="tablePreview" class="table">'
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

$HTTPStatusCodes = @{ 
	100 = "Continue"
	101 = "Switching Protocols"
	102 = "Processing (WebDAV - RFC 2518)"
	103 = "Checkpoint"
	200 = "OK"
	201 = "Created"
	202 = "Accepted"
	203 = "Non-Authoritative Information (HTTP 1.1)"
	204 = "No Content"
	205 = "Reset Content"
	206 = "Partial Content"
	207 = "Multi-Status (Multi-Status, WebDAV)"
	208 = "Already Reported (WebDAV)"
	300 = "Multiple Choices"
	301 = "Moved Permanently"
	302 = "Found"
	303 = "See Other (HTTP 1.1)"
	304 = "Not Modified"
	305 = "Use Proxy (HTTP 1.1)"
	306 = "Switch Proxy"
	307 = "Temporary Redirect (HTTP 1.1)"
	308 = "Permanent Redirect"
	400 = "Bad Request"
	401 = "Unauthorized"
	402 = "Payment Required"
	403 = "Forbidden"
	404 = "Not Found"
	405 = "Method Not Allowed"
	406 = "Not Acceptable"
	407 = "Proxy Authentication Required"
	408 = "Request Timeout"
	409 = "Conflict"
	410 = "Gone"
	411 = "Length Required"
	412 = "Precondition Failed"
	413 = "Request Entity Too Large"
	414 = "Request-URI Too Long"
	415 = "Unsupported Media Type"
	416 = "Requested Range Not Satisfiable"
	417 = "Expectation Failed"
	418 = "I'm a teapot"
	422 = "Unprocessable Entity (WebDAV - RFC 4918)"
	423 = "Locked (WebDAV - RFC 4918)"
	424 = "Failed Dependency (WebDAV) (RFC 4918)"
	425 = "Unassigned"
	426 = "Upgrade Required (RFC 7231)"
	428 = "Precondition Required"
	429 = "Too Many Requests"
	431 = "Request Header Fields Too Large)"
	449 = "Microsoft"
	451 = "Unavailable for Legal Reasons"
	500 = "Internal Server Error"
	501 = "Not Implemented"
	502 = "Bad Gateway"
	503 = "Service Unavailable"
	504 = "Gateway Timeout"
	505 = "HTTP Version Not Supported"
	506 = "Variant Also Negotiates (RFC 2295)"
	507 = "Insufficient Storage (WebDAV - RFC 4918)"
	508 = "Loop Detected (WebDAV)"
	509 = "Bandwidth Limit Exceeded"
	510 = "Not Extended (RFC 2774)"
	511 = "Network Authentication Required"
	512 = "Not updated"
	521 = "Version Mismatch"
}

