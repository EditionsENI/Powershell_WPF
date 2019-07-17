[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("PS1_WPF_PasswordBox.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Password_User = $form.FindName("PasswordBox")
$OkButton = $form.FindName("Ok")

$OkButton.Add_click({

    $MDP = $Password_User.password.tostring()
    Write-Host "le mot de passe est $MDP    "

})

$Form.ShowDialog() | Out-Null