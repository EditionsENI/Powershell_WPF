#################################################
# This Script accepts 4 parameters from the command line
#
# Tenantname - Mandatory - To form SPO Admin Url and OneDrive Url Prefix.
# Username - Mandatory - Global Tenant Administrator account to query all OneDrive User Profiles
# Password - Mandatory - Global Tenant Administrator password
# OutputFile - Optional - File path to save the Output CSV file.
#
#
# Use the below command to run the script
#
# .\Get-OneDriveStorageReport.ps1 -Tenantname xxxxxx -Username admin@xxxxxx.onmicrosoft.com -Password pass@word1 -OutputFile "C:\Reports\OneDrive_Size_Report.csv"
#
# NOTE: If you don't pass an output file path to the script, it will save the output file in C drive (C:\OneDrive_Size_Report.csv) 
#
# Author: 		Morgan
# Version: 		1.0
# Last Modified Date: 	02/01/2017
# Website: 	        http://www.morgantechspace.com
# Help/Source Url:      https://technet.microsoft.com/en-us/library/dn911464.aspx
##################################################################################################

#Accept input parameters
Param(
	[Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $Tenantname,
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $Username,
	[Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
    [string] $Password,
	[Parameter(Position=2, Mandatory=$false, ValueFromPipeline=$true)]
    [string] $OutputFile
)

#Check if we have been passed an input file path
if ($OutputFile -eq "")
{
  $OutputFile="C:\OneDrive_Size_Report.csv"    	
}

# Varibale to hold the processed output
$Result=@() 

# Load Required SharePoint Client SDK Assemblies to use CSOM
$loadInfo1 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
$loadInfo2 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
$loadInfo3 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.UserProfiles")

# Setting SharePoint Online Administration Site url 
$AdminURI = "https://" + $Tenantname +"-admin.sharepoint.com"
# Setting OneDrive Site url Prefix
$OneDrivePrefixUrl="https://" + $Tenantname +"-my.sharepoint.com"

$SecPwd = $Password | ConvertTo-SecureString -AsPlainText -Force
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $SecPwd)
$UserCredential = New-Object System.Management.Automation.PSCredential -argumentlist $Username, $SecPwd

# Add the path of the User Profile Service to the SPO admin URL, then create a new webservice proxy to access it
$proxyaddr = "$AdminURI/_vti_bin/UserProfileService.asmx?wsdl"
$UserProfileService= New-WebServiceProxy -Uri $proxyaddr -UseDefaultCredential False
$UserProfileService.Credentials = $creds

Write-Progress -activity "Fetching User Profiles" -status "..........."

# Set variables for authentication cookies
$strAuthCookie = $creds.GetAuthenticationCookie($AdminURI)
$uri = New-Object System.Uri($AdminURI)
$container = New-Object System.Net.CookieContainer
$container.SetCookies($uri, $strAuthCookie)
$UserProfileService.CookieContainer = $container

# Sets the first User profile, at index -1
$UserProfileResult = $UserProfileService.GetUserProfileByIndex(-1)
Write-Host "Starting- This could take a while."
$NumProfiles = $UserProfileService.GetUserProfileCount()
$i = 1

Connect-SPOService -Url $AdminURI -Credential $UserCredential

# As long as the next User profile is NOT the one we started with (at -1)...
While ($UserProfileResult.NextValue -ne -1) 
{
Write-Progress -activity "Processing User Profiles" -status "$i out of $NumProfiles completed"
# Look for the Personal Space object in the User Profile and retrieve it
# (PersonalSpace is the name of the path to a user's OneDrive for Business site. 
# Users who have not yet created a  OneDrive for Business site might not have this property)
$Prop = $UserProfileResult.UserProfile | Where-Object { $_.Name -eq "PersonalSpace" } 
$Url= $Prop.Values[0].Value
 
# If "PersonalSpace" exists, then OneDrive Profile provisioned for the user...
if ($Url) {
$siteurl = $OneDrivePrefixUrl + $Url.Substring(0,$Url.Length-1)

# Find size and storage limit
$temp = Get-SPOSite $siteurl -Detailed
if($temp)
{
$Result += New-Object PSObject -property @{ 
UserName = $temp.Title
UserPrincipalName = $temp.Owner
TotalSize_MB = $temp.StorageUsageCurrent
TotalSize_GB = $temp.StorageUsageCurrent/1024
StorageQuota_GB = $temp.StorageQuota/1024
WarningSize_GB =  $temp.StorageQuotaWarningLevel/1024
}
}

}

# And now we check the next profile the same way...
$UserProfileResult = $UserProfileService.GetUserProfileByIndex($UserProfileResult.NextValue)
$i++
}
$Result | Select-object -property UserName,UserPrincipalName,TotalSize_MB,TotalSize_GB,StorageQuota_GB,WarningSize_GB |Export-CSV $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "OneDrive for Business Storage Report successfully exported to "$OutputFile -foregroundcolor Green