[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Change_Color = $form.FindName("Change_Color")
$Red = $form.FindName("Red")
$Yellow = $form.FindName("Yellow")
$Green = $form.FindName("Green")
$MyEllipse = $form.FindName("MyEllipse")


$Change_Color.Add_SelectionChanged({	

    If ($Red.IsSelected -eq $true) 
		{					
			$MyEllipse.Fill = "Red"					
		} 
	ElseIf ($Yellow.IsSelected -eq $true) 
		{	
			$MyEllipse.Fill = "Yellow"					
		}
	ElseIf ($Green.IsSelected -eq $true) 
		{	
			$MyEllipse.Fill = "Green"					
		}		
})	





$Form.ShowDialog() | Out-Null

