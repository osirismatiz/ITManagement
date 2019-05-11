$smtpServer = "172.25.9.116"
$smtpPort = 25
$smtpUser = "Anonymous"
$smtpPass = "Anonymous"

function SendMessageNoSSL{
	param([Parameter(Mandatory=$true)]$emailFrom, 
			[Parameter(Mandatory=$true)]$emailTo, 
			[Parameter(Mandatory=$true)]$emailSubject, 
			[Parameter(Mandatory=$true)]$emailBody
			)
	Try{
		WriteLog "INFO" ("Sending email ...") $SCRIPTNAME
		
		$SMTPMessage = New-Object Net.Mail.MailMessage

		$SMTPMessage.From = $emailFrom
		$SMTPMessage.To.Add($emailTo)

		$SMTPMessage.subject = $emailSubject
		$SMTPMessage.IsBodyHTML = $true
		$SMTPMessage.Body = $emailBody

		$SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort) 
		$SMTPClient.EnableSsl = $false 
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("anonymous", "nopass"); 
		$SMTPClient.Send($SMTPMessage)
	}
	Catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[SendMessageNoSSL] $FailedItem. The error message was $ErrorMessage $Error[0].Exception ($PSItem.ScriptStackTrace)" $SCRIPTNAME -ErrorAction Stop
		#Continue
	}
	Finally
	{
		#Get-Date 
	}
}

function SendMessage{
	param([Parameter(Mandatory=$true)]$emailFrom, 
			[Parameter(Mandatory=$true)]$emailTo, 
			[Parameter(Mandatory=$true)]$emailSubject, 
			[Parameter(Mandatory=$true)]$emailBody
			)
	Try{
		WriteLog "INFO" ("Sending email ...") $SCRIPTNAME
		
		$SMTPMessage = New-Object Net.Mail.MailMessage

		$SMTPMessage.From = $emailFrom
		$SMTPMessage.To.Add($emailTo)

		$SMTPMessage.subject = $emailSubject
		$SMTPMessage.IsBodyHTML = $true
		$SMTPMessage.Body = $emailBody

		$SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort) 
		$SMTPClient.EnableSsl = $true 
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass); 
		$SMTPClient.Send($SMTPMessage)
	}
	Catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[SendMessage] $FailedItem. The error message was $ErrorMessage $Error[0].Exception ($PSItem.ScriptStackTrace)" $SCRIPTNAME -ErrorAction Stop
		#Continue
	}
	Finally
	{
		#Get-Date 
	}
}

function SendMessageWithAttachment{
	param([Parameter(Mandatory=$true)]$emailFrom, 
			[Parameter(Mandatory=$true)]$emailTo, 
			[Parameter(Mandatory=$true)]$emailSubject, 
			[Parameter(Mandatory=$true)]$emailBody,
			[Parameter(Mandatory=$true)]$emailAttachmentPath
			)
	Try{
		WriteLog "INFO" ("Sending email ...") $SCRIPTNAME
		
		$SMTPMessage = New-Object Net.Mail.MailMessage

		$SMTPMessage.From = $emailFrom
		$SMTPMessage.To.Add($emailTo)

		$SMTPMessage.subject = $emailSubject
		$SMTPMessage.IsBodyHTML = $true
		$SMTPMessage.Body = $emailBody

		$attachment = New-Object System.Net.Mail.Attachment($emailAttachmentPath)
		$SMTPMessage.Attachments.Add($attachment)

		$SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort) 
		$SMTPClient.EnableSsl = $true 
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass); 
		$SMTPClient.Send($SMTPMessage)
		$attachment.Dispose();
	}
	Catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
		WriteLog "ERROR" "[SendMessageWithAttachment] $FailedItem. The error message was $ErrorMessage $Error[0].Exception ($PSItem.ScriptStackTrace)" $SCRIPTNAME -ErrorAction Stop
		#Continue
	}
	Finally
	{
		#Get-Date 
	}
}
