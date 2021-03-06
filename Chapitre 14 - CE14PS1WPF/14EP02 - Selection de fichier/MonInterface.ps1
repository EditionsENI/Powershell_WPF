#================================================================================================================
#
# Author 		 : Damien VAN ROBAEYS
#
#================================================================================================================


[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll')      | out-null  

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
[System.Windows.Forms.Application]::EnableVisualStyles()

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

#************************************************************************** DATAGRID *******************************************************************************************************************
$Browse = $form.FindName("Browse")
$TextBox = $form.FindName("TextBox")


$Browse.Add_Click({
$Dialogue_Fichier = New-Object System.Windows.Forms.OpenFileDialog
# $Dialogue_Fichier.Filter = "Excel File (.csv)|*.csv; |TXT File (.txt)|*.txt;"
$Dialogue_Fichier.Filter = "Excel File (.csv)|*.csv|TXT File (.txt)|*.txt;"

# $Dialogue_Fichier.Filter = "CSV File (.csv)|*.csv;"

$Dialogue_Fichier.title = "Choisir le fichier CSV"	
$Dialogue_Fichier.ShowHelp = $True	
$Dialogue_Fichier.initialDirectory = [Environment]::GetFolderPath("Desktop")
$Dialogue_Fichier.ShowDialog() | Out-Null
	
$CheminComplet_Fichier = $Dialogue_Fichier.filename	
$Nom_SansExtension = [System.IO.Path]::GetFileNameWithoutExtension($CheminComplet_Fichier)	
$TextBox.Text = $CheminComplet_Fichier
})







$Form.ShowDialog() | Out-Null

