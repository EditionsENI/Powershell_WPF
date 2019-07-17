[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[xml]$MonXAML = @"
<Window 
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Title="Interface WPF - Chapitre 4" Width="380" Height="200">
<Grid>	
<StackPanel Orientation="Vertical" HorizontalAlignment="Center" Margin="0,10,0,0">
<Label Content="Notre interface WPF" FontSize="20" HorizontalAlignment="Center"/>
<GroupBox Header="Chargement du dossier" Margin="0,10,0,0" Height="65" Width="300">
<StackPanel Orientation="Horizontal" Margin="0,0,0,0" HorizontalAlignment="Center">
<Button Name="MonBouton" Content="Browse" Width="80" Height="20"/>
<TextBox Name="MonTextBox" Width="200" Height="20"/>
</StackPanel>
</GroupBox>
</StackPanel>		
</Grid>
</Window> 
"@ 

$reader=(New-Object System.Xml.XmlNodeReader $MonXAML)
$MonInterface=[Windows.Markup.XamlReader]::Load( $reader )
$MonBouton = $MonInterface.FindName("MonBouton") 
$MonTextBox = $MonInterface.FindName("MonTextBox") 
$MonInterface.ShowDialog() | Out-Null
