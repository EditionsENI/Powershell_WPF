[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null 
[System.Reflection.Assembly]::LoadFrom('assembly\ModernChrome.dll')      | out-null  


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$DataGrid_Machines = $form.FindName("DataGrid_Machines")
$DataGrid_Utilisateurs = $form.FindName("DataGrid_Utilisateurs")
$BTN_Redemarrer = $form.FindName("BTN_Redemarrer")
$BTN_Eteindre = $form.FindName("BTN_Eteindre")

Function Populate_Datagrid_Machines
	{
		$Machines_XML = [xml](get-content "Liste_Machines.xml")
		$Liste_Machines = $Machines_XML.Ordinateurs.Ordinateur
		ForEach ($Machine in $Liste_Machines)
			{
				$Machine_Valeur = New-Object PSObject
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty Nom $Machine.Nom -passthru	
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty Localisation $Machine.Localisation -passthru									
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty OS $Machine.OS -passthru									
				$DataGrid_Machines.Items.Add($Machine_Valeur) > $null						
			}						
	}
	
Function Populate_Datagrid_Utilisateurs
	{
		$Utilisateurs_XML = [xml] (get-content "Liste_Utilisateurs.xml")
		$Liste_Utilisateurs = $Utilisateurs_XML.Utilisateurs.Utilisateur
		ForEach ($Utilisateur in $Liste_Utilisateurs)
			{
				$Utilisateur_Valeur = New-Object PSObject
				$Utilisateur_Valeur = $Utilisateur_Valeur | Add-Member NoteProperty Nom $Utilisateur.Nom -passthru	
				$Utilisateur_Valeur = $Utilisateur_Valeur | Add-Member NoteProperty Localisation $Utilisateur.Localisation -passthru									
				$DataGrid_Utilisateurs.Items.Add($Utilisateur_Valeur) > $null						
			}						
	}	

Populate_Datagrid_Machines
Populate_Datagrid_Utilisateurs











$Form.ShowDialog() | Out-Null

