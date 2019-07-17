[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[xml]$MonXAML = get-content -path "MonProjet.xaml"
$Reader=(New-Object System.Xml.XmlNodeReader $MonXAML)
$Interface = [Windows.Markup.XamlReader]::Load($Reader)

$MonBouton = $Interface.FindName("MonBouton") 
$MonTextBox = $Interface.FindName("MonTextBox") 

$Interface.ShowDialog() | Out-Null
