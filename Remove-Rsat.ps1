<# Some RSAT FoD have dependencies and need to be uninstalled in the
   corret order.
   Some RSAT FoD may require a reboot. The reboot is required before
   trying to uninstall a dependent FoD.
   If a reboot is required or a FoD failes to uninstall because of dependencies,
   exit code 3010 is returned. In this case, reboot the device and launch the
   script again.
   There should be no dependency related failures, if the order below isn't
   changed and a reboot is executed each time a 3010 is returned.

   The reboots can be handled automatically by SCCM based on the return code.
   As long as the detection method detects the package as installed,
   the script will be launched again by SCCM. You can use a footprint
   (e.g. in the registry) for the detection method and remove it only,
   after all FoD have been uninstalled (see if-statement at the very end).
#>
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