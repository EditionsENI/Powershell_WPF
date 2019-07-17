[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\CharacterProgressControl.dll')       				| out-null


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("CharcaterProgress_WPF_PS1.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Progress1 = $form.findname("Progress1") 
$Progress2 = $form.findname("Progress2") 
$Progress3 = $form.findname("Progress3") 
$Progress4 = $form.findname("Progress4") 
$Progress5 = $form.findname("Progress5") 
$Progress6 = $form.findname("Progress6") 

$Value = 10
$Progress1.Value = $Value
$Progress2.Value = $Value
$Progress3.Value = $Value
$Progress4.Value = $Value
$Progress5.Value = $Value
$Progress6.Value = $Value


$Form.ShowDialog() | Out-Null