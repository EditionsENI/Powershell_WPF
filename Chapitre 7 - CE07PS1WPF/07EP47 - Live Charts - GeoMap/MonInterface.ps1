[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.Wpf.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.WeatherIcons.dll')      | out-null  


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Nantes = $form.FindName("Nantes")
$WNantes = $form.FindName("WNantes")
$Lyon = $form.FindName("Lyon")
$WLyon = $form.FindName("WLyon")
$Paris = $form.FindName("Paris")
$WParis = $form.FindName("WParis")

$Nantes.Add_MouseEnter({

$WNantes.Visibility = "Visible"
})
    
$Lyon.Add_MouseEnter({

$WLyon.Visibility = "Visible"
})

$Paris.Add_MouseEnter({

$WParis.Visibility = "Visible"
})
    
$Nantes.Add_MouseLeave({

$WNantes.Visibility = "Hidden"
})

$Lyon.Add_MouseLeave({

$WLyon.Visibility = "Hidden"

})
        
$Paris.Add_MouseLeave({
        
$WParis.Visibility = "Hidden"
})
            

$Form.ShowDialog() | Out-Null

