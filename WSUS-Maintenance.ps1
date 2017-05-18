# WSUS-Maintenance.ps1
# https://github.com/timkent/wsus-scripts

try {
    [reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
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

Remove-Variable license, updates

# WSUS maintenance tasks
if ($cleanupScope = new-object Microsoft.UpdateServices.Administration.CleanupScope) {
    $cleanupScope.DeclineSupersededUpdates = $true
    $cleanupScope.DeclineExpiredUpdates = $true
    $cleanupScope.CleanupObsoleteUpdates = $true
    $cleanupScope.CompressUpdates = $true
    $cleanupScope.CleanupObsoleteComputers = $true
    $cleanupScope.CleanupUnneededContentFiles = $true
    if ($cleanupManager = $wsus.GetCleanupManager()) {
        $cleanupManager.PerformCleanup($cleanupScope)
    }
}
