[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll')  |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignThemes.Wpf.dll') 		 |Out-Null	
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignColors.dll')       	 |Out-Null	
[System.Reflection.Assembly]::LoadFrom('assembly\Dragablz.dll')       	 |Out-Null	


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$Form.ShowDialog() | Out-Null