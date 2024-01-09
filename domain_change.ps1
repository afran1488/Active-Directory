#I made this script to help a client who got a new domain name. After adding the domain to M365, users needed to get a new proxyaddress but retain the previous one as an alias.
Import-Module ActiveDirectory

# Set the path to the CSV file
$csvPath = "cutover.csv"

# Read the second CSV file
$csvData = Import-Csv $csvPath

# Iterate over each row in the second CSV file
foreach ($row in $csvData) {
    # Retrieve the user account
    $sAMAccountName = $row.sAMAccountName
    $user = Get-ADUser -Filter "sAMAccountName -eq '$sAMAccountName'"

    # Add aliases from 'Alias' column
    $aliases = $row.Alias -split ';'
    $user.proxyAddresses += $aliases

    # Add proxyAddresses from 'NewPrimary' column
    $newPrimaryAddresses = $row.NewPrimary -split ';'
    $user.proxyAddresses += $newPrimaryAddresses

    # Update the 'mail' attribute
    $user.mail = $row.mail

    # Save the changes
    Set-ADUser -Instance $user
}