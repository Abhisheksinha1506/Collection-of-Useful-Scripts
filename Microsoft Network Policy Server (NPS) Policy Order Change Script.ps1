<#
When Using Microsoft NPS (Formerly IAS) for RADIUS, if you want to change the processing order of your network policies, you have to right click > Move up, Right Click > Move Up. One at a time, for each policy. If you have hundreds of policies this can take ages.

The config for IAS is actually in an XML file in C:\Windows\System32\IAS.xml.And since this is such a shit old product, you can just edit the XML directly and you don't even need to restart the service.
#>





#Default Location for NPS (IAS) Config File
$IASConfigFile = "C:\windows\system32\ias\ias.xml"

#Create a backup
Copy-Item $IASConfigFile "$(($IASConfigFile).trimend(".xml"))_BACKUP_$(get-date -f MMddyy_HHmm).xml" -Force

#Load the XML
$IASConfig =  [XML] (get-content -path $IASConfigFile)

#Enter the Policy Name you want to change
$Policy = read-host "Enter the policy name you want to change"

#Enter where you want it to be
[int]$NewNumber = Read-Host "Enter the new order number"

#The XML replaces dashes and spaces with underscores, so do that too. 
#Sometimes people will copy from a word doc and their - will end up a special unicode – so replace that too. 
$Policy = $Policy.replace("-","_").replace("–","_").replace(" ","_")

#get Info on the Policy you want to change
$PolicyInfo = $IASConfig.root.children.Microsoft_Internet_Authentication_Service.children.NetworkPolicy.children.$($Policy)
[int]$PolicyCurrentNumber = $PolicyInfo.Properties.msNPSequence.'#text'

#Build a reference list that can be used to reference the original positions of the policies
$ReferenceList = $IASConfig.root.children.Microsoft_Internet_Authentication_Service.children.NetworkPolicy.children.ChildNodes |Select Name,@{l='ProcessingOrder';e={[int]$_.Properties.msNPSequence.'#text'}}

#Set the Current Processing number to be where you want your policy to end up. 
#We need to move all the policies between the current and new number up/down by one. 
[int]$CurrentProcessing = $NewNumber

#Decide if you're going up or down. 
if ($NewNumber -lt $PolicyCurrentNumber){
    do{
        #Find the current policy we're moving in the reference list. This contains the original processing order. 
        $CurrentReferencePolicy = $ReferenceList |?{$_.ProcessingOrder -eq $($CurrentProcessing)}

        #Use the reference to find the policy you're moving in the config. We need to do this because as you shift, for a brief time two policies will have the same processing order. 
        $CurrentProcessingPolicy = $IASConfig.root.children.Microsoft_Internet_Authentication_Service.children.NetworkPolicy.children."$($CurrentReferencePolicy.Name.replace("-","_").replace("–","_").replace(" ","_"))"
        
        #Set the new number on the policy, moving it down the list
        $CurrentProcessingPolicy.Properties.msNPSequence.'#text'= [string]$($CurrentProcessing+1)
        Write-Host "Changing $($CurrentProcessingPolicy.Name) from $($CurrentReferencePolicy.ProcessingOrder) to $($CurrentProcessing+1)"
        
        #On to the next one. 
        $CurrentProcessing++
    }
    until ($CurrentProcessing -eq $PolicyCurrentNumber)

    }
elseif ($NewNumber -gt $PolicyCurrentNumber){
    do{
        #Find the current policy we're moving in the reference list. This contains the original processing order. 
        $CurrentReferencePolicy = $ReferenceList |?{$_.ProcessingOrder -eq $($CurrentProcessing)}
        
        #Use the reference to find the policy you're moving in the config. We need to do this because as you shift, for a brief time two policies will have the same processing order. 
        $CurrentProcessingPolicy = $IASConfig.root.children.Microsoft_Internet_Authentication_Service.children.NetworkPolicy.children."$($CurrentReferencePolicy.Name.replace("-","_").replace("–","_").replace(" ","_"))"
        
        #Set the new number on the policy, moving it up in the list 
        $CurrentProcessingPolicy.Properties.msNPSequence.'#text'= [string]$($CurrentProcessing-1)
        Write-Host "Changing $($CurrentProcessingPolicy.Name) from $($CurrentReferencePolicy.ProcessingOrder) to $($CurrentProcessing-1)"
        
        #On to the next one
        $CurrentProcessing--        
    }
    until ($CurrentProcessing -eq $PolicyCurrentNumber)
    }
else {
      Write-Host -BackgroundColor Red -ForegroundColor Yellow "Current number and New Number are the same. Aborting"
      Continue
     }

#Once you've shuffled the others, update the policy you wanted to move. 
Write-Host "Changing $($Policy) from $($PolicyCurrentNumber) to $($NewNumber)"
$PolicyInfo.Properties.msNPSequence.'#text'= [string]$($NewNumber)

#Save the file 
$IASConfig.save($IASConfigFile)