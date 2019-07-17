[System.Reflection.Assembly]::LoadFrom('Assembly\MahApps.Metro.dll')      
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Testing_GUI.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$Cliquez = $Form.findname("Cliquez") 

$Cliquez.Add_Click({
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Bonjour ENI :-)", "PowerShell et WPF")		
})






$Form.ShowDialog() | Out-Null