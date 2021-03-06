[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

[xml]$MonXAML = get-content -path "MonProjet.xaml"
$Reader=(New-Object System.Xml.XmlNodeReader $MonXAML)
$Interface = [Windows.Markup.XamlReader]::Load($Reader)
[System.Windows.Forms.Application]::EnableVisualStyles() 

$MonBouton = $Interface.FindName("MonBouton") 
$MonTextBox = $Interface.FindName("MonTextBox") 

$MonBouton.Add_Click({
	Add-Type -AssemblyName System.Windows.Forms
	$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
	[void]$FolderBrowser.ShowDialog()	
	$MonTextBox.Text = $FolderBrowser.SelectedPath
})

$Interface.Add_Closing({
	$_.Cancel = $true
	$Resultat = [System.Windows.Forms.MessageBox]::Show('Voulez-vous fermer l application ?', 'Warning', 'YesNo', 'Warning')
	If ($Resultat -eq 'Yes')
	{
		$_.Cancel = $false	
		$Interface.Close()
	}
})

$Interface.ShowDialog() | Out-Null

