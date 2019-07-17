[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_ComboBox.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$ComboBox = $form.FindName("ComboBox1")
$ComboBox.SelectedIndex = 0


$Form.ShowDialog() | Out-Null