[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll')  |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\GongSolutions.WPF.DragDrop.dll')  |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\ControlzEx.dll')  |Out-Null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')  |Out-Null


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