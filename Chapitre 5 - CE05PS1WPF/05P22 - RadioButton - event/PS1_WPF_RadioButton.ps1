[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_RadioButton.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$WPF_Oui = $Form.FindName("WPF_Oui")
$WPF_Non = $Form.FindName("WPF_Non")
$WPF_OuiNon = $Form.FindName("WPF_OuiNon")
$WPF_Resultat = $Form.FindName("WPF_Resultat")



$WPF_Resultat.Add_Click({
If($WPF_Oui.IsChecked -eq $True)
	{
		write-host "Oui on aime"
	}
ElseIf($WPF_Non.IsChecked -eq $True)
	{
		write-host "Non on aime pas"
	}
ElseIf($WPF_OuiNon.IsChecked -eq $True)
	{
		write-host "Peut-etre bien que oui, peut-etre bien que non"
	}	
})

$Form.ShowDialog() | Out-Null