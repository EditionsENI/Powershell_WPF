[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$MonInterfaceDynamique = $form.FindName("MonInterfaceDynamique")

$StackPanel = New-Object System.Windows.Controls.StackPanel
$StackPanel.Name        = "MonStackPanel" 
$StackPanel.Orientation = "Vertical"
$StackPanel.VerticalAlignment   = "Center"
$StackPanel.HorizontalAlignment   = "Center"
$MonInterfaceDynamique.Children.Add($StackPanel) 

$Label = New-Object System.Windows.Controls.Label
$Label.Name = "Monlabel"
$Label.Content="PowerShell et WPF"
$Label.ForeGround="Red"
$Label.FontSize="20"
$Label.FontWeight="Bold"
$StackPanel.Children.Add($Label)      

$Form.ShowDialog() | Out-Null