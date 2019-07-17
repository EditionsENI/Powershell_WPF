[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.Wpf.dll')      | out-null  


function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$XamlMainWindow=LoadXml("MonInterface.xaml")

$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Doughnut  = $Form.FindName("Doughnut")

$DoughnutCollection = [LiveCharts.SeriesCollection]::new()

$chartvalue1 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
$chartvalue1.Add([LiveCharts.Defaults.ObservableValue]::new($(Get-Random -Minimum 60 -Maximum 80)))
$pieSeries.Values = $chartvalue1
$pieSeries.Title = "Chrome"
$pieSeries.DataLabels = $true

$DoughnutCollection.Add($pieSeries)


$chartvalue2 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
$chartvalue2.Add([LiveCharts.Defaults.ObservableValue]::new($(Get-Random -Minimum 30 -Maximum 60)))
$pieSeries.Values = $chartvalue2
$pieSeries.Title = "Mozilla"
$pieSeries.DataLabels = $true

$DoughnutCollection.Add($pieSeries)


$chartvalue3 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
$chartvalue3.Add([LiveCharts.Defaults.ObservableValue]::new($(Get-Random -Minimum 5 -Maximum 13)))
$pieSeries.Values = $chartvalue3
$pieSeries.Title = "Opera"
$pieSeries.DataLabels = $true


$DoughnutCollection.Add($pieSeries)

$chartvalue4 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
$chartvalue4.Add([LiveCharts.Defaults.ObservableValue]::new($(Get-Random -Minimum 10 -Maximum 30)))
$pieSeries.Values = $chartvalue4
$pieSeries.Title = "Explorer"
$pieSeries.DataLabels = $true


$DoughnutCollection.Add($pieSeries)

$Doughnut.Series = $DoughnutCollection


$Form.ShowDialog() | Out-Null

