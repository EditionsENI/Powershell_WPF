[System.Reflection.Assembly]::LoadFrom('Assembly\MahApps.Metro.dll')      
[System.Reflection.Assembly]::LoadFrom('Assembly\System.Windows.Interactivity.dll') 
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Testing_GUI.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$ShowDialog = $Form.findname("ShowDialog") 
$ShowDialog.Add_Click({		
    $Identifiants = [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalLoginExternal($Form,"Bonjour ENI","Saisir vos identifiants") 
    $User_Login = $Identifiants.Username
    $User_PWD  = $Identifiants.Password	
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Vos identifiants", "Utilisateur: $User_Login - Mot de passe: $User_PWD")		
})



$Form.ShowDialog() | Out-Null