$packages =
'Rsat.CertificateServices.Tools~~~~0.0.1.0',
'Rsat.DHCP.Tools~~~~0.0.1.0',
'Rsat.Dns.Tools~~~~0.0.1.0',
'Rsat.IPAM.Client.Tools~~~~0.0.1.0',
'Rsat.LLDP.Tools~~~~0.0.1.0',
'Rsat.NetworkController.Tools~~~~0.0.1.0',
'Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0',
'Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0',
'Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0',
'Rsat.Shielded.VM.Tools~~~~0.0.1.0',
'Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0',
'Rsat.StorageReplica.Tools~~~~0.0.1.0',
'Rsat.SystemInsights.Management.Tools~~~~0.0.1.0',
'Rsat.VolumeActivation.Tools~~~~0.0.1.0',
'Rsat.WSUS.Tools~~~~0.0.1.0',
'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0',
'Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0',
'Rsat.FileServices.Tools~~~~0.0.1.0',
'Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0',
'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
'Rsat.ServerManager.Tools~~~~0.0.1.0'

foreach ($package in $packages) {
  Write-Output -InputObject $package
  if ($null -ne (Get-WindowsCapability -Name $package -Online | Where-Object -Property State -EQ -Value Installed)) {
    Write-Output -InputObject "  removing..."
    try {
      $result = Remove-WindowsCapability -Name $package -Online -ErrorAction Stop
      if ($result.RestartNeeded) {
        Write-Output -InputObject "  reboot required. suspending script..."
        Exit 3010
      }
      else {
        Write-Output -InputObject "  success!"
      }     
    }
    catch {
      Write-Output -InputObject "  uninstall failed. reboot required. suspending script..."
      Exit 3010
    }
  }
  else {
    Write-Output -InputObject "  not installed..."
  }
}

if ($null -eq (Get-WindowsCapability -Name RSAT* -Online | Where-Object -Property State -EQ -Value Installed)) {
  # Remove footprint here
}