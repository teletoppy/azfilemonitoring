###### PowerShell to compare file storage in each FileShare #####

###### Connect to Azure Account #####
######  To Be Done for connectivity ######


#parameters


$allStorageAccounts = 'Storage Accounts under Subscription with Resource Group'
$shareStorageAccounts = 'Share account under each storage'
$shareMetaUsage = 'to keep number of ShareUsageBytes and quota'
$thresholdAlert = 80 #value to alert

#get all share/storage account under subscription
$allStorageAccounts = (Get-AzStorageAccount|Select-Object StorageAccountName, ResourceGroupName)

foreach($line in $allStorageAccounts) {
    #get the share storage from each account here 
    $shareStorageAccounts = (Get-AzRmStorageShare -ResourceGroupName $line.ResourceGroupName -StorageAccountName $line.StorageAccountName|Select-Object Name, StorageAccountName, ResourceGroupName, QuotaGiB, ShareUsageBytes)

    #loop through each share storage accounts
    foreach($share in $shareStorageAccounts) {
        #get the actual usage size in byte
        $shareMetaUsage = (Get-AzRmStorageShare -ResourceGroupName $share.ResourceGroupName -StorageAccountName $share.StorageAccountName -Name $share.Name -GetShareUsage|Select-Object Name, QuotaGiB, ShareUsageBytes)
        

        #Construct object - to make it easy to display if require
        $fsSummary = [PSCustomObject]@{
            StorageAcctName   = $share.StorageAccountName
            ResourceGroupName = $share.ResourceGroupName
            ShareName         = $share.Name
            'Quota GB'        = [int64]$share.QuotaGiB
            'Usage GB'        = [math]::round($shareMetaUsage.ShareUsageBytes/1Gb,2)
            'Used Capacity %' = [math]::round(($shareMetaUsage.ShareUsageBytes/1Gb)*100/[int64]($share.QuotaGiB),2)
        }

        #Display results for each for shareline for teting
        #$fsSummary
        
       # if comparison is required in order to check with Threshold before raising alarm
       $thresholdReached = $fsSummary | Where-Object { ($_.'Used Capacity %') -gt $thresholdAlert }
	 
	if($thresholdReached){
		Write-Host "Red:" $fsSummary.StorageAcctName, $$fsSummary.ShareName
		$fsSummary
	}else{
		Write-Host "Green:" $fsSummary.StorageAcctName, $fsSummary.ShareName
	}
    }
}