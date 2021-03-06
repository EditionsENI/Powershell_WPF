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
Add-Type -AssemblyName System.Windows.Forms
$MonDossier_Object = New-Object System.Windows.Forms.FolderBrowserDialog
[void]$MonDossier_Object.ShowDialog()	
$Script:MonDossier = $MonDossier_Object.SelectedPath	
$Nom_Court = Split-Path -Leaf $MonDossier
$TextBox.Text = $MonDossier	
})




# Add-Type -AssemblyName System.Windows.Forms
# $MonDossier_Object = New-Object System.Windows.Forms.FolderBrowserDialog
# [void]$MonDossier_Object.ShowDialog()	
# $Script:MonDossier = $MonDossier_Object.SelectedPath	
# $Nom_Court = Split-Path -Leaf $MonDossier
# $TextBox.Text = $Nom_Court	


# $Browse.Add_Click({
	# Add-Type -AssemblyName System.Windows.Forms
	# $MonDossier_Object = New-Object System.Windows.Forms.FolderBrowserDialog
	# [void]$MonDossier_Object.ShowDialog()	
	# $Script:MonDossier = $MonDossier_Object.SelectedPath	
	# $Nom_Court = Split-Path -Leaf $MonDossier
	
	# $Nom_Court = Split-Path -literalpath $MonDossier
	# $DirtyExtension = [io.path]::GetExtension("$SelectedSource") 
	# $splitSourceFile = $DirtyExtension.split(".")	
	
	# $TextBox.Text = $Nom_Court
	
# })



$Form.ShowDialog() | Out-Null

