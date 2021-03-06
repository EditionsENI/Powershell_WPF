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
# Erreur
$title = "Chapitre 14"
$message = "PowerShell et WPF"
[reflection.assembly]::loadwithpartialname("System.Windows.Forms")
[reflection.assembly]::loadwithpartialname("System.Drawing")
$path = Get-Process -id $pid | Select-Object -ExpandProperty Path            		
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)    		
$notify = new-object system.windows.forms.notifyicon
$notify.icon = $icon
$notify.visible = $true
$notify.showballoontip(10,$title,$Message, `				
[system.windows.forms.tooltipicon]::error)	

# Information
# $title = "Chapitre 14"
# $message = "PowerShell et WPF"
# [reflection.assembly]::loadwithpartialname("System.Windows.Forms")
# [reflection.assembly]::loadwithpartialname("System.Drawing")
# $path = Get-Process -id $pid | Select-Object -ExpandProperty Path            		
# $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)    		
# $notify = new-object system.windows.forms.notifyicon
# $notify.icon = $icon
# $notify.visible = $true
# $notify.showballoontip(10,$title,$Message, `				
# [system.windows.forms.tooltipicon]::info)	

})




$Form.ShowDialog() | Out-Null

