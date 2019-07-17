#================================================================================================================
#
# Author 		 : Damien VAN ROBAEYS
#
#================================================================================================================

$Global:Current_Folder = split-path $MyInvocation.MyCommand.Path


[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom("$Current_Folder\assembly\MahApps.Metro.dll")       				| out-null
[System.Reflection.Assembly]::LoadFrom("$Current_Folder\assembly\MahApps.Metro.IconPacks.dll")      | out-null  

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("$Current_Folder\MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

[System.Windows.Forms.Application]::EnableVisualStyles()

$MonBouton = $form.FindName("MonBouton")
$Choose_Theme = $form.FindName("Choose_Theme")
$Theme_Dark = $form.FindName("Theme_Dark")
$Theme_Light = $form.FindName("Theme_Light")
$Choose_Accent = $form.FindName("Choose_Accent")
$Accent_Cobalt = $form.FindName("Accent_Cobalt")
$Accent_Red = $form.FindName("Accent_Red")
$Accent_Pink = $form.FindName("Accent_Pink")

$MonBouton.Add_Click({
	$Theme = [MahApps.Metro.ThemeManager]::DetectAppStyle($form)	
	$my_theme = ($Theme.Item1).name
	If($my_theme -eq "BaseLight")
		{
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseDark"));		
				
		}
	ElseIf($my_theme -eq "BaseDark")
		{					
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseLight"));			
		}		
})

$Choose_Theme.Add_SelectionChanged({	
	$Theme = [MahApps.Metro.ThemeManager]::DetectAppStyle($form)	
    If ($Theme_Dark.IsSelected -eq $true) 
		{					
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseDark"));		
		} 
	Else 
		{	
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseLight"));		
		}
})	

$Choose_Accent.Add_SelectionChanged({	
	$Theme = [MahApps.Metro.ThemeManager]::DetectAppStyle($form)	
    If ($Accent_Cobalt.IsSelected -eq $true) 
		{					
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, [MahApps.Metro.ThemeManager]::GetAccent("Cobalt"), $Theme.Item1);	
		} 
	ElseIf ($Accent_Red.IsSelected -eq $true) 
		{	
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, [MahApps.Metro.ThemeManager]::GetAccent("Red"), $Theme.Item1);	
		}
	ElseIf ($Accent_Pink.IsSelected -eq $true) 
		{	
			[MahApps.Metro.ThemeManager]::ChangeAppStyle($form, [MahApps.Metro.ThemeManager]::GetAccent("Pink"), $Theme.Item1);	
		}		
})	

$Form.ShowDialog() | Out-Null

