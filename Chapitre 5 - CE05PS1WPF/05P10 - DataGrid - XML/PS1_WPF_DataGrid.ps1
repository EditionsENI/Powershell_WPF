[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_DataGrid.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$Datagrid_Machines = $Form.findname("Datagrid_Machines") 




Function Populate_Datagrid
	{[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory=$true,
					   ValueFromPipelineByPropertyName=$true,
					   Position=0)]
			$File
	
			
		)
		$Machines_XML = [xml](get-content "$File")
		$Liste_Machines = $Machines_XML.Computers.Computer
		ForEach ($Machine in $Liste_Machines)
			{
				$Machine_Valeur = New-Object PSObject
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty Nom $Machine.Name -passthru	
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty Status $Machine.Status -passthru									
				$Machine_Valeur = $Machine_Valeur | Add-Member NoteProperty Ville $Machine.Ville -passthru									
				$DataGrid_Machines.Items.Add($Machine_Valeur) > $null						
			}						
	}
	
Populate_Datagrid -File Liste_Machines.xml


$Form.ShowDialog() | Out-Null