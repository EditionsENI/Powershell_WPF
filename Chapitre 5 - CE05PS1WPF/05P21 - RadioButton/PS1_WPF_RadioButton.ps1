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

# $RadioButtonGrp1 = $Form.FindName("Grp1")
# $RadioButtonGrp2 = $Form.FindName("Grp2")

$WPF_Oui = $Form.FindName("WPF_Oui")
$WPF_Non = $Form.FindName("WPF_Non")
$WPF_OuiNon = $Form.FindName("WPF_OuiNon")


$WPF_Oui.Add_Click({
	write-host "Oui on aime"
})

$WPF_Non.Add_Click({
	write-host "Non on aime pas"
})

$WPF_OuiNon.Add_Click({
	write-host "Peut-etre bien que oui, peut-etre bien que non"
})



# $RadioButtonGrp1.Add_PreviewMouseDown({
    # Write-Host $_.source.GroupName 
    # Write-Host $_.source.Content
# If($RadioButtonGrp1.IsSelected -eq $True)
	# {
		# write-host "Checkbox 1 coche"
	# }
# Else
	# {
		# write-host "Checkbox 1 decoche"
	# }
# })









$Form.ShowDialog() | Out-Null