# RSAT Installer
The scripts can be used to silently install or uninstall the complete RSAT suite with SCCM. As of Win 10 1809, RSAT is installed as a Feature on Demand (FoD). There is no standalone installer anymore.
Dependencies and pending reboots must be handled carefully.
The uninstall script relies on the Application Model of SCCM and the fact that the script will be launched again, if the detection method is not satisfied. The scripts have a placeholder for a custom footprint that you want to use as the detection method. Use a registry key or alike for the footprint.

## Install
Installation is quite straight forward.

Call the script with `powershell -ExecutionPolicy Bypass -NoProfile -File Add-Rsat.ps1`.

## Uninstall
Some RSAT FoD have dependencies and need to be uninstalled in the
corret order.
Some RSAT FoD may require a reboot. The reboot is required before
trying to uninstall a dependent FoD.
Configure the SCCM Deployment Type to *Determine behavior based on return codes*.
If a reboot is required or a FoD failes to uninstall because of dependencies,
exit code 3010 is returned. In this case, SCCM will reboot the device and launch the
script again until all FoD are removed.
There should be no dependency related failures, if the order in the `$packages` variable isn't
changed.

Call the script with `powershell -ExecutionPolicy Bypass -NoProfile -File Remove-Rsat.ps1`.