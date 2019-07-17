[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
# [System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_DataGrid.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

# Recherche de le control Button qui a comme nom Button
$Button = $Form.findname("Button") 
$Valeurs = $Form.findname("Valeur") 

$Label = $Form.findname("Label") 
$DataGrid = $Form.findname("DataGrid") 

# Evenement Add_Click 
$Button.Add_Click({

    $InstalledModule = Get-InstalledModule
	$NbModInstalled = $InstalledModule.count
	foreach ($Value in $InstalledModule)
				{
					$ModuleName = $Value.Name
					$ModuleVersion = $Value.Version
					$PowerMod_values = New-Object PSObject
					$PowerMod_values = $PowerMod_values | Add-Member NoteProperty Name $Value.Name -passthru
					$PowerMod_values = $PowerMod_values | Add-Member NoteProperty Version $Value.Version -passthru
					$PowerMod_values = $PowerMod_values | Add-Member NoteProperty Repository $Value.Repository -passthru
					$DataGrid.Items.Add($PowerMod_values) > $null
				}

    
    $Label.Content="Il y a $NbModInstalled modules PowerShell "

})

$Valeurs.Add_Click({

	if ($DataGrid.SelectedItems -ne $null)
	{
		$Name = $DataGrid.SelectedItems.Name
		$Version = $DataGrid.SelectedItems.Version
		$Repository = $DataGrid.SelectedItems.Repository

		write-host "Vous avez selectionné le module PowerShell $Name qui est en version $Version installée depuis le dépot $Repository"

	}
})

$Form.ShowDialog() | Out-Null