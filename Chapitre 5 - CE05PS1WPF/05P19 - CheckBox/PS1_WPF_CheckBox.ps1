[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_CheckBox.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$MyCheckBox1   = $Form.FindName("MyCheckBox1")
$MyCheckBox2   = $Form.FindName("MyCheckBox2")
$MyCheckBox3   = $Form.FindName("MyCheckBox3")

# $MyCheckBox1.Add_Click({
# If($MyCheckBox1.IsChecked -eq $True)
	# {
		# write-host "Checkbox 1 coche"
	# }
# Else
	# {
		# "Checkbox 1 decoche"
	# }
# })

$MyCheckBox1.Add_Checked({
    write-host "Checkbox 1 coche"
})

$MyCheckBox2.Add_Checked({
    write-host "Checkbox 2 coche"
})

$MyCheckBox3.Add_Checked({
    write-host "Checkbox 3 coche"
})

$MyCheckBox1.Add_Unchecked({
    write-host "Checkbox 1 decoche"
})

$MyCheckBox2.Add_Unchecked({
    write-host "Checkbox 2 decoche"
})

$MyCheckBox3.Add_Unchecked({
    write-host "Checkbox 3 decoche"
})





$Form.ShowDialog() | Out-Null