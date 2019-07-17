


  
    #Grabs the Monitor objects from WMI
    $Monitors = Get-WmiObject -Namespace "root\WMI" -Class "WMIMonitorID" -ErrorAction SilentlyContinue
    
    #Creates an empty array to hold the data
    $Monitor_Array = @()

    #Takes each monitor object found and runs the following code:
    ForEach ($Monitor in $Monitors) {
      
      $Mon_Serial_Number = ([System.Text.Encoding]::ASCII.GetString($Monitor.SerialNumberID)).Replace("$([char]0x0000)","")
      $Mon_Manufacturer = ([System.Text.Encoding]::ASCII.GetString($Monitor.ManufacturerName)).Replace("$([char]0x0000)","")

      #Creates a custom monitor object and fills it with 4 NoteProperty members and the respective data
      $Monitor_Obj = [PSCustomObject]@{
        Model            = $Mon_Model
        SerialNumber     = $Mon_Serial_Number
      }
      
      #Appends the object to the array
      $Monitor_Array += $Monitor_Obj

    } #End ForEach Monitor
  
    #Outputs the Array
    $Monitor_Array
    
