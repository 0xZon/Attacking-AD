#Get LDAP Path
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain() #This will get the domain name and domain controller 

$PDC = ($domainObj.PdcRoleOwner).Name #Save the name of the domain controller into PDC i.e. DC01.corp.com

#The next few lines will build a LDAP query -- LDAP://HostName[:PortNumber][/DistinguishedName]

$SearchString = "LDAP://" 

$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))" # This is chaning corp.com to look like DC=corp,DC=com

$SearchString += $DistinguishedName

$SearchString #This will give us the full LDAP provider path LDAP://DC01.corp.com/DC=corp,DC=com

#Use LDAP path with DirectorySearcher to start doing queries 
$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

$objDomain = New-Object System.DirectoryServices.DirectoryEntry($SearchString, "corp.com\offsec", "lab") #Authentication in order to query LDAP

$Searcher.SearchRoot = $objDomain #This will search the entirety of LDAP LDAP://DC01.corp.com/DC=corp,DC=com -> LDAP://DC01.corp.com/OU=groups,DC=corp,DC=com -> LDAP://DC01.corp.com/OU=admins,OU=groups,DC=corp,DC=com


#Filters so we can find information that we want

#This filters on the object property that we want, the below is on user accounts, other examples could be name=FIRST LAST or memberof=GROUPS
#To view all of the items that you want to filter on comment out the line below and look at each object
$Searcher.filter="samAccountType=805306368" # 0x30000000 (decimal 805306368) 

$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop
    }
    
    Write-Host "------------------------"
}