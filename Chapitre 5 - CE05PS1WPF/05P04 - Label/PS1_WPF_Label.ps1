[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
# [System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_Label.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

# Recherche de le control Button qui a comme nom Button
$Button = $Form.findname("Button") 
$Label = $Form.findname("Label") 

# Evenement Add_Click 
$Button.Add_Click({

    write-host "Je change le contenu du Label"
    $Label.Content="ENI Editions PowerShell et WPF"
})



$Form.ShowDialog() | Out-Null