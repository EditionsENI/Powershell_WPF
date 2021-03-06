# Load assemblies
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null


# Load XAML
function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}
$XamlMainWindow=LoadXml("Interface_WPF.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


# Show GUI
$Form.ShowDialog() | Out-Null
