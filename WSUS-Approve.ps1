[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
 
# Accept EULA for all updates
$updates = $wsus.GetUpdates()
$license = $updates | Where-Object {$_.RequiresLicenseAgreementAcceptance}
$license | ForEach-Object {$_.AcceptLicenseAgreement()}
 
# Accept for All Computers and subgroups
$group = $wsus.GetComputerTargetGroups() | Where-Object {$_.Name -Eq "All Computers"}
 
$updates | Where-Object {($_.UpdateClassificationTitle -Eq "Critical Updates" -Or $_.UpdateClassificationTitle -Eq "Security Updates" -Or $_.UpdateClassificationTitle -Eq "Service Packs" -Or $_.UpdateClassificationTitle -Eq "Update Rollups") -And (-Not $_.IsDeclined)} | ForEach {
    $_.Approve("Install", $group)
}
