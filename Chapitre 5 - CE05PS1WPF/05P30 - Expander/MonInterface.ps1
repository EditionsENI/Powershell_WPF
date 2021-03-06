[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[xml]$MonXAML = get-content -path "MonInterface.xaml"
$Reader=(New-Object System.Xml.XmlNodeReader $MonXAML)
$Interface = [Windows.Markup.XamlReader]::Load($Reader)

$MonBouton = $Interface.FindName("MonBouton") 
$MonTextBox = $Interface.FindName("MonTextBox") 

$MonBouton.Add_Click({
	Add-Type -AssemblyName System.Windows.Forms
	$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
	[void]$FolderBrowser.ShowDialog()	
	$MonTextBox.Text = $FolderBrowser.SelectedPath
})

$MonBouton.Add_MouseRightButtonDown({
	$MonTextBox.Text = ""
})



$MonBouton.Add_Click({
	# Déplier l'Expander 
	$MonExpander.IsExpanded = $True
	# Replier l'Expander 
	$MonExpander.IsExpanded = $False
})


$Interface.ShowDialog() | Out-Null

