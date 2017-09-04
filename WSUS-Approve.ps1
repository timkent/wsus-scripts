# WSUS-Approve.ps1
# https://github.com/timkent/wsus-scripts

try {
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
    $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
}
catch {
    throw "Problem running GetUpdateServer()"
}

try {
    $updates = $wsus.GetUpdates()
}
catch {
    throw "Problem running GetUpdates()"
}

# Accept EULA for all updates
if ($license = $updates | Where-Object {$_.RequiresLicenseAgreementAcceptance}) {
    $license | ForEach-Object {$_.AcceptLicenseAgreement()}
}

# Accept for All Computers and subgroups
if ($group = $wsus.GetComputerTargetGroups() | Where-Object {$_.Name -Eq "All Computers"}) {
    # Unfortunately we can't use (-Not $_.IsApproved) here as it is set when the update is approved in any group/subgroup
    $updates | Where-Object {($_.UpdateClassificationTitle -Eq "Critical Updates" -Or $_.UpdateClassificationTitle -Eq "Security Updates" -Or $_.UpdateClassificationTitle -Eq "Service Packs" -Or $_.UpdateClassificationTitle -Eq "Update Rollups") -And (-Not $_.IsDeclined)} | ForEach-Object {
        $_.Approve("Install", $group) | Out-Null
    }
}
