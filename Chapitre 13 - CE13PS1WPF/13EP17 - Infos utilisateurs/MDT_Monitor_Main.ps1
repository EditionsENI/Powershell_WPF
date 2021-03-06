#================================================================================================================
#
# Author 		 : Damien VAN ROBAEYS
#
#================================================================================================================


[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.dll')        | out-null  	
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.Wpf.dll') 	 | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll')      | out-null  

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("MDT_Monitor_Main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

#************************************************************************** DATAGRID *******************************************************************************************************************
$Doughnut = $form.FindName("Doughnut")

$OS_Titre = $form.FindName("OS_Titre")
$OS_Version = $form.FindName("OS_Version")
$Processeur = $form.FindName("Processeur")
$Memory = $form.FindName("Memory")
$Graphisme = $form.FindName("Graphisme")
$Serial = $form.FindName("Serial")
$My_Disk_Info = $form.FindName("My_Disk_Info")
$Ma_Machine = $form.FindName("Ma_Machine")
$Refresh_Once = $form.FindName("Refresh_Once")
$Mon_FARO = $form.FindName("Mon_FARO")
$Tab_control = $form.FindName("Tab_control")
$Pending_Reboot = $form.FindName("Pending_Reboot")
$IsRebootRequired = $form.FindName("IsRebootRequired")
$MonitorList = $form.FindName("MonitorList")

$Doughnut_OneDrive = $form.FindName("Doughnut_OneDrive")
$My_OneDrive_Info = $form.FindName("My_OneDrive_Info")


$User = $env:USERPROFILE
$ProgData = $env:PROGRAMDATA
$Date = get-date -format "dd-MM-yy_HHmm"
$Global:Current_Folder =(get-location).path 
$object = New-Object -comObject Shell.Application  




$Win32_ComputerSystem = Get-ciminstance Win32_ComputerSystem 
$Win32_BIOS = Get-ciminstance Win32_BIOS 


$Win32_OperatingSystem = Get-ciminstance Win32_OperatingSystem 

$Manufacturer = $Win32_ComputerSystem.manufacturer	
$MTM = $Win32_ComputerSystem.Model
$Serial_Number = $Win32_BIOS.SerialNumber
$Memory_RAM = [Math]::Round(($Win32_ComputerSystem.TotalPhysicalMemory/ 1GB),1) 

$REG_OS_Version = get-itemproperty -path registry::"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -erroraction 'silentlycontinue'


$OS_Ver = $Win32_OperatingSystem.version
$Build_number = $Win32_OperatingSystem.buildnumber
If ($OS_Ver -like "10*")
    {
        $OS_ReleaseID =  $REG_OS_Version.ReleaseID
    }
Else
    {
        $OS_ReleaseID = ""
    }

$Computer_Model = $Win32_ComputerSystem.Model
	
	
$Win32_LogicalDisk = Get-ciminstance Win32_LogicalDisk | where {$_.DeviceID -eq "C:"}

$Total_size = [Math]::Round(($Win32_LogicalDisk.size/1GB),1)
$Free_size = [Math]::Round(($Win32_LogicalDisk.Freespace/1GB),1) 
$Disk_information =  $Disk_information + "(" + $Win32_LogicalDisk.deviceid + ") " + $Total_size + " GB (Espace total) / " +  + $Free_size + " GB (Espace libre) `n"
	

$My_Disk_Info.Content = $Disk_information
	
	
$Ma_Machine.Content = "Nom de ma machine: " + $env:computername	
	
$Graphic_Card = (Get-CimInstance CIM_VideoController).caption	
$OS_Titre.Content = $Computer_Model


$OS_Version.Content =  "Windows 10 - $OS_ReleaseID"

$Mon_FARO.Content = "Utilisateur: " + $env:username

$Graphisme.Content = "Graphisme: $Graphic_Card"


$Memory.Content = "Mémoire: $Memory_RAM GB"
$Serial.Content = "Numéro de série: SEDGR3Z"
# $Serial.Content = "Numéro de série: $Serial_Number"




function Test-PendingReboot
{
 if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
 if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
 if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
 try { 
   $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
   $status = $util.DetermineIfRebootPending()
   if(($status -ne $null) -and $status.RebootPending){
     return $true
   }
 }catch{}
 
 return $false
}




If ((Test-PendingReboot) -eq $true)
	{
		$Pending_Reboot.Visibility = "Visible"
	}
Else
	{
		$Pending_Reboot.Visibility = "Collapsed"
	}	

# =================== StackPanel ======================================== 
Function Create-StackPanel{ 
 [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string] $StackPanelName,
        [Parameter(Position=1,Mandatory=$true)]
        [string] $StackPanelMarign,
        [Parameter(Position=2,Mandatory=$true)]
        [string] $StackPanelOrientation,
        [Parameter(Position=3)]
        [string] $StackPanelAlignment)

 
    $StackPanel = New-Object System.Windows.Controls.StackPanel
    $StackPanel.Name        = $StackPanelName 
    $StackPanel.Orientation = $StackPanelOrientation
    $StackPanel.Margin      = $StackPanelMarign
    $StackPanel.VerticalAlignment   = "Stretch"
    if($StackPanelMarign -eq "") {$StackPanel.HorizontalAlignment = "Center"}
    else{$StackPanel.HorizontalAlignment = $StackPanelAlignment} 

    return $StackPanel
}

# ======================== Label =======================================
Function Create-Label{ 
 [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string] $LabelName,
        [Parameter(Position=1,Mandatory=$true)]
        [string] $LabelMargin)
 
    $Label = New-Object System.Windows.Controls.Label
    $Label.Name        = $LabelName 
    $Label.Margin      = $LabelMargin
    $Label.FontSize="16"
    
    return $Label
}

# ======================== Image =======================================
Function Create-Image{ 
 [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string] $ImageName,
        [Parameter(Position=1,Mandatory=$true)]
        [string] $ImageSize,
        [Parameter(Position=2)]
        [string] $ImageMargin)
 
    $Image = New-Object System.Windows.Controls.Image
    $Image.Name        = $RadioButtonName
    if($ImageMargin -ne "") {$Image.Margin  = $ImageMargin }
    $Image.Width =$ImageSize.Split(",")[0]
    $Image.Height=$ImageSize.Split(",")[1]
    $Image.HorizontalAlignment="Center"
    $Image.VerticalAlignment="Top" 
    
    return $Image
}

# ======================== Border =======================================
Function Create-Border{ 
 [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string] $BorderName,
        [Parameter(Position=1,Mandatory=$true)]
        [string] $Margin,
        [Parameter(Position=2)]
        [string] $Background)
 
    $Border = New-Object System.Windows.Controls.Border
    $Border.Name           = $BorderName 
    if(($Background -ne "") -and ($Background -ne $null)){$Border.Background     = $Background}
    $Border.HorizontalAlignment = "Stretch"
    $Border.VerticalAlignment="Stretch"
    $Border.BorderBrush = "WhiteSmoke"
    $Border.CornerRadius    = 5
    $Border.BorderThickness = 1
    $Border.Margin     = $Margin 
    return $Border
}


	
	
	
Function Get_Monitor
	{
		$WMI1_WmiMonitorId = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorId 
		$Global:AllMonitors = ForEach($WMI1 in $WMI1_WmiMonitorId)
			{
				$WMI1_InstanceName = $WMI1.InstanceName
				$WMI1_FriendlyName = $WMI1.UserFriendlyName

				If ($WMI1_FriendlyName -gt 0) 
					{
						$name = ($WMI1.UserFriendlyName -notmatch '^0$' | foreach {[char]$_}) -join ""
					}
				Else 
					{
						$name = 'Moniteur interne'
					}				
					
					
				$WMI2_WmiMonitorListedSupportedSourceModes = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedSupportedSourceModes 
				ForEach($WMI2 in $WMI2_WmiMonitorListedSupportedSourceModes)
					{
						$WMI2_InstanceName = $WMI2.InstanceName
						If($WMI1_InstanceName -eq $WMI2_InstanceName)
							{
								$maxres = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedSupportedSourceModes | Select-Object -ExpandProperty MonitorSourceModes | Sort-Object -Property {$_.HorizontalActivePixels * $_.VerticalActivePixels} -Descending #| Select-Object -First 1												
							}				
					}			
					
				$WMI3_WmiMonitorBasicDisplayParams = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams	
				ForEach($WMI3 in $WMI3_WmiMonitorBasicDisplayParams)
					{
						$WMI3_InstanceName = $WMI3.InstanceName
						If($WMI1_InstanceName -eq $WMI3_InstanceName)
							{
								$Monitor_Size = $WMI3 | select  @{N="Computer"; E={$_.__SERVER}},
								@{N="Size";
								E={[System.Math]::Round(([System.Math]::Sqrt([System.Math]::Pow($_.MaxHorizontalImageSize, 2) + [System.Math]::Pow($_.MaxVerticalImageSize, 2))/2.54),2)}}						
							}									
					}

				$Prop = @{
				'Name' = $name
				'Serial' = (($WMI1.SerialNumberID -notmatch '^0$' | foreach {[char]$_}) -join "")
				'Size' = $Monitor_Size.size
				}
				New-Object -Type PSObject -Property $Prop				

			}
	}	
	


function Create_Monitor_Content{
	Get_Monitor
	$StackPanelmain = Create-StackPanel "StackPanelAllDisk" "0,0,0,0" "Horizontal" "Center" 

    foreach ($disk in $AllMonitors ){             

         $StackPanelparent  = [String]("StackPparent"+$disk.Serial)
         $StackforPartition = [String]("StackForPart"+$disk.Serial)
         $Borderdisk        = [String]("BorderOf_"+$disk.Serial)
         $StackforPartition = Create-StackPanel  $StackforPartition "0,0,0,0" "Horizontal" "Center"
         $StackPanelparent  = Create-StackPanel  $StackPanelparent "0,0,0,0" "Vertical" "Center"  # inside the block
         $Borderdisk        = Create-Border      $Borderdisk  "10,30,0,0"
		 $Borderdisk.BorderThickness = "0"

         #======================= disk_n ==================================  
         $Titre_Label  	  = [String]("Disk_"+$disk.Serial )
         $Monitor_Pic         = [String]("Disk_"+$disk.Serial+"_ico" )
         $ChildSizeInfo   = [String]("Disk_"+$disk.Serial+"_size" )
         $Carte_LabelInfo   = [String]("Disk_"+$disk.Serial+"_size" )		
         $Serial_LabelInfo   = [String]("Disk_"+$disk.Serial+"_size" )		 		 
         $StackPaneldisk  = [String]("Disk_"+$disk.Serial+"_stackP" )
               
         $StackPaneldisk  = Create-StackPanel  $StackPaneldisk  "0,0,0,0" "Vertical" "Center"
         $DiskManagIco    = Create-Image       $Monitor_Pic "100,90" "5,5,0,0"
         $Titre_Label  = Create-Label       $Titre_Label  "5,0,0,0"    #Disk Id
         $Resolution_Label   = Create-Label       $ChildSizeInfo   "5,0,0,0"
         $Carte_Label   = Create-Label       $Carte_LabelInfo   "5,0,0,0"
         $Serial_Label   = Create-Label       $Serial_LabelInfo   "5,0,0,0"

         $DiskManagIco.Source    =".\images\monitor.png" 
         $Titre_Label.Content = $disk.Name
		 $Titre_Label.FontWeight = "Bold"
		 $Titre_Label.FontSize = "20"

		 $Monitor_Size = $disk.size
		 $Monitor_Size = [math]::Round($Monitor_Size)
         $Resolution_Label.Content  = "Taille: " + $Monitor_Size + " pouces"		 
		 $Resolution_Label.FontSize = "14"
         $Carte_Label.Content  = $Graphic_Card
		 $Carte_Label.FontSize = "14"		 

         $Serial_Label.Content  = "Serial: " + $disk.serial 
		 $Serial_Label.FontSize = "14"			 
		 
         $StackPaneldisk.Children.Add($DiskManagIco)
         $StackPaneldisk.Children.Add($Titre_Label)
         $StackPaneldisk.Children.Add($Carte_Label)
         $StackPaneldisk.Children.Add($Serial_Label)		 
         $StackPaneldisk.Children.Add($Resolution_Label)
        
         $StackPanelparent.Width = 200
         $StackPanelparent.Height = 260
         $StackPanelparent.Children.Add($StackPaneldisk)

         $Titre_Label.Foreground = "White"
         $Resolution_Label.Foreground = "White"
         $Carte_Label.Foreground = "White"
         $Serial_Label.Foreground = "White"
             
         $StackforPartition.Children.Add($StackPanelparent) 

        $Borderdisk.Child = $StackforPartition
        $StackPanelmain.Children.Add($Borderdisk)
    }  
    $MonitorList.Children.Add($StackPanelmain)      
}
	
	
	
	
	
	
	
Create_Monitor_Content	
	
	
	
	
	



Function Check_Folder_Size
	{
		param(
		$Folder_Path
		)	
		
		If (test-path $Folder_Path)
			{
				Try
					{
						$Get_Folder_Size = (gci $Folder_Path -recurse -file -ea silentlycontinue -ErrorVariable err | measure-object -property length -sum).sum
					}
				Catch 
					{					
						"KO ==> Issue while checking size of $Folder" 							
						write-host ""
						write-host "################################################# ISSUE REPORTED #################################################" 								
						$_.Exception.ToString()
						write-host "################################################# ISSUE REPORTED #################################################" 								
						$Global:LastExitCode = 1
					}			

				If ($Get_Folder_Size -eq $null)
					{
						$folderSizeOutput = "0"
					}						
				ElseIf ( $Get_Folder_Size -lt 1KB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f $Get_Folder_Size) B" 
					}
				ElseIf ( $Get_Folder_Size -lt 1MB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f ($Get_Folder_Size / 1KB)) KB" 
					}
				ElseIf ( $Get_Folder_Size -lt 1GB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f ($Get_Folder_Size / 1MB)) MB" 
					}
				ElseIf ( $Get_Folder_Size -lt 1TB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f ($Get_Folder_Size / 1GB)) GB" 
					}
				ElseIf ( $Get_Folder_Size -lt 1PB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f ($Get_Folder_Size / 1TB)) TB" 
					}
				ElseIf ( $Get_Folder_Size -ge 1PB ) 
					{ 
						$folderSizeOutput = "$("{0:N2}" -f ($Get_Folder_Size / 1PB)) PB" 
					}	
								
				$Global:Full_Folder_Size = New-Object -TypeName psobject
				$Full_Folder_Size | Add-Member -MemberType NoteProperty -Name Size_Formated -Value $folderSizeOutput
				$Full_Folder_Size | Add-Member -MemberType NoteProperty -Name Size_Normal  -Value $Get_Folder_Size					
			}
		Else
			{
				write-host "Can not find the folder $Folder_Path" 									
			}		
		Return $Full_Folder_Size
	}

# Function Analyze_Disk_Size
	# {
	
	
		$OneDrive_Commercial_Folder = $env:OneDriveCommercial	
	
		# $documents_Size = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Documents").Size_Normal
		# $download_size = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Downloads").Size_Normal
		# $desktop_size = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Desktop").Size_Normal
		# $music_size = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Music").Size_Normal

		# $documents_Size_Formated = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Documents").Size_Formated
		# $download_size_Formated = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Downloads").Size_Formated
		# $desktop_size_Formated = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Desktop").Size_Formated
		# $music_size_Formated = (Check_Folder_Size -Folder_Path "C:\Users\damien.van robaeys\Music").Size_Formated

		$Total_size = [Math]::Round(($Win32_LogicalDisk.size/1GB),1)
		$Total_size_full = $Win32_LogicalDisk.size
		$Free_Space = $Win32_LogicalDisk.FreeSpace

		$Free_Space_Formated = "$("{0:N2}" -f ($Free_Space / 1GB)) GB" 

		$Doc_Used_Size = '{0:N0}' -f (($documents_Size / $Total_size_full * 100),1)
		$download_Used_Size = '{0:N0}' -f (($download_size / $Total_size_full * 100),1)
		$desktop_Used_Size = '{0:N0}' -f (($desktop_size / $Total_size_full * 100),1)
		$music_Used_Size = '{0:N0}' -f (($music_size / $Total_size_full * 100),1)
		$Free_Space_Used_Size = '{0:N0}' -f (($Free_Space / $Total_size_full * 100),1)
	# }
		
		
$My_OneDrive_Info.Content = "OneDrive status: $OD_size_Formated (Espace total) / $OD_size_Formated (Espace synchronisés)"		
		
		
		
		
		
		
		
Function Show_Chart_Stockage
	{				
		$DoughnutCollection = [LiveCharts.SeriesCollection]::new()

		$chartvalue1 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
		$pieSeries = [LiveCharts.Wpf.PieSeries]::new()

		If($Doc_Used_Size -gt 0)
			{
				$chartvalue1.Add([LiveCharts.Defaults.ObservableValue]::new($Doc_Used_Size))
			}
		$pieSeries.Values = $chartvalue1
		$pieSeries.Title = "Mes documents ($documents_Size_Formated)"
		$pieSeries.DataLabels = $true
		$DoughnutCollection.Add($pieSeries)


		$chartvalue2 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
		$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
		If($desktop_Used_Size -gt 0)
			{
				$chartvalue2.Add([LiveCharts.Defaults.ObservableValue]::new($desktop_Used_Size))
			}
		$pieSeries.Values = $chartvalue2
		$pieSeries.Title = "Mon bureau ($desktop_size_Formated)"
		$pieSeries.DataLabels = $true
		$DoughnutCollection.Add($pieSeries)

		$chartvalue3 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
		$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
		If($music_Used_Size -gt 0)
			{
				$chartvalue3.Add([LiveCharts.Defaults.ObservableValue]::new($music_Used_Size))	
			}
		$pieSeries.Values = $chartvalue3
		$pieSeries.Title = "Ma musique ($music_size_Formated)"
		$pieSeries.DataLabels = $true
		$DoughnutCollection.Add($pieSeries)


		$chartvalue4 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
		$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
		If($download_Used_Size -gt 0)
			{
				$chartvalue4.Add([LiveCharts.Defaults.ObservableValue]::new($download_Used_Size))
			}
		$pieSeries.Values = $chartvalue4
		$pieSeries.Title = "Téléchargements ($download_size_Formated)"
		$pieSeries.DataLabels = $true
		$DoughnutCollection.Add($pieSeries)

		$chartvalue5 = [LiveCharts.ChartValues[LiveCharts.Defaults.ObservableValue]]::new()
		$pieSeries = [LiveCharts.Wpf.PieSeries]::new()
		If($Free_Space_Used_Size -gt 0)
			{
				$chartvalue5.Add([LiveCharts.Defaults.ObservableValue]::new($Free_Space_Used_Size))
			}
		$pieSeries.Values = $chartvalue5
		$pieSeries.Title = "Espace libre ($Free_Space_Formated)"
		$pieSeries.DataLabels = $true
		$DoughnutCollection.Add($pieSeries)

		$Doughnut.Series = $DoughnutCollection
	}



	
	
	
	


$Tab_Control.Add_SelectionChanged({	
	If ($Tab_Control.SelectedItem.Header -eq "Stockage")
		{
			Show_Chart_Stockage		
		}	
	ElseIf ($Tab_Control.SelectedItem.Header -eq "Moniteurs")
		{
			$MonitorList.Children.Clear()     

			Get_Monitor
			Create_Monitor_Content					
		}		
})

$Refresh_Once.Add_Click({
	Show_Chart_Stockage
})	



$Form.ShowDialog() | Out-Null

