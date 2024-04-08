# Senaria
This repository contains a bunch of scripts used to automate various activities.

- **CopySecretsBetweenKeyVaults.ps1**: This scripts copy all the secrets from a source KeyVault to a destination KeyVault. It requires the user that is authenticated to Azure via `az login` to have the `Secret Officer` role on both key Vaults.
- **SelfElevateToAdmin.ps1**: Automates the addition of a specified user to the local "Administrators" group on a Windows machine by scheduling a task to run under the SYSTEM account.
