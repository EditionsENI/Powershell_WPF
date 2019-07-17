[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\RadialMenu.dll')      | out-null  


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Close = $form.FindName("Close")
$MonPremierMenu = $form.FindName("MonPremierMenu")
$BoutonOuvrir = $form.FindName("BoutonOuvrir")

$BoutonOuvrir.Visibility = "Collapsed"

# Bouton fermeture du menu
$Close.Add_Click({
	$MonPremierMenu.IsOpen = $false
	$BoutonOuvrir.Visibility = "Visible"
})

# Bouton ouverture du menu
$BoutonOuvrir.Add_Click({
	$MonPremierMenu.IsOpen = $true
	$BoutonOuvrir.Visibility = "Collapsed"
})

$Form.ShowDialog() | Out-Null

