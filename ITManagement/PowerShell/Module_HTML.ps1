<#
$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@

$Header = @"
<link rel='stylesheet' href='styles.css'>
"@


$StyleCSS = Get-Content -Path '.\styles.css' 

$Header = @"
<style>
$StyleCSS
</style>
"@

#>

$Header = @'
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
'@

Get-PSDrive | ConvertTo-Html -Property Name,Used,Provider,Root,CurrentLocation -Head $Header | Out-File -FilePath PSDrives2.html

# Get-PSDrive | ConvertTo-Xml -Property Name,Used,Provider,Root,CurrentLocation | Out-File -FilePath PSDrives.xml