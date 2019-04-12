Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

if ($null -eq (Get-WindowsCapability -Name RSAT* -Online | Where-Object -Property State -EQ -Value NotPresent)) {
  # Set footprint here
}