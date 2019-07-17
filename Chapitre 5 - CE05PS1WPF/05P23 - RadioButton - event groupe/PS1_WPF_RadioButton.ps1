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

$Grp1 = $Form.FindName("Grp1")
$Grp1 = $Form.FindName("Grp2")

$Grp1.Add_PreviewMouseDown({
    Write-Host $_.source.GroupName 
    Write-Host $_.source.Content
})

$Grp1.Add_PreviewMouseDown({
    Write-Host $_.source.GroupName 
    Write-Host $_.source.Content
})









$Form.ShowDialog() | Out-Null