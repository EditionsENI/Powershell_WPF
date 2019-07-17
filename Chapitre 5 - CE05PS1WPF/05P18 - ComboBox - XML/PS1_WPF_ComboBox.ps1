[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_ComboBox.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)
$ComboBox1 = $Form.findname("ComboBox1") 
$ComboBox2 = $Form.findname("ComboBox2") 

Function Populate_ComboBox
	{[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory=$true,
					   ValueFromPipelineByPropertyName=$true,
					   Position=0)]
			$File,
			[Parameter(Mandatory=$true,
			ValueFromPipelineByPropertyName=$true,
			Position=1)]
			[ValidateSet("Nom", "Localisation")]
			$Type

		)
		$Utilisateurs_XML = [xml](get-content "$File")
		$Liste_Users = $Utilisateurs_XML.Utilisateurs.Utilisateur
		ForEach ($Users in $Liste_Users)
			{
				$Users_Valeur = New-Object PSObject
				$Users_Valeur = $Users_Valeur | Add-Member NoteProperty $Type $Users.$Type -passthru	
				switch ($Type) {
					'Nom' 
					{ 
						$ComboBox1.Items.Add($Users_Valeur.$Type) > $null						
					}
					'Localisation'
					{
						$ComboBox2.Items.Add($Users_Valeur.$Type) > $null						
					}
					Default {}
				}
			}						
	}


	Populate_ComboBox -File Liste_Utilisateurs.xml -Type Nom
	Populate_ComboBox -File Liste_Utilisateurs.xml -Type Localisation

$ComboBox1.SelectedIndex = 0
$ComboBox2.SelectedIndex = 0

$Form.ShowDialog() | Out-Null