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


$Browse.Add_Click({
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF")
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 0, 0)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 0, 16)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 0, 64)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 0, 48)


# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 1, 64)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 2, 64)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 3, 64)
$reponse = [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 4, 64)
# [System.Windows.Forms.MessageBox]::Show("PowerShell et WPF", "Chapitre 14" , 5, 64)
[System.Windows.Forms.MessageBox]::Show("$reponse")

})


# [System.Windows.Forms.MessageBox]::Show("Message", "Titre" , $Bouton, $Icon)


# 0 : OK
# 1 : OK Cancel
# 2 : Abort Retry Ignore
# 3 : Yes No Cancel
# 4 : Yes No
# 5 : Retry Cancel





# 0 : Aucune icône
# 16 : Icône erreur 
# 48 : Icône avertissement 
# 64 : Icône information 




$Form.ShowDialog() | Out-Null

