# #############################################################################
# # OUTPUTS Recover Services Vault and Azure VM Backup Policy
# #############################################################################

output "map_recovery_vaults" {
  value = {
    for rv_k, rv_v in var.recovery_services_vaults :
    rv_k => {
      recovery_vault_name = azurerm_recovery_services_vault.this[rv_k].name # The Name of the Recovery Services Vault.
      recovery_vault_id   = azurerm_recovery_services_vault.this[rv_k].id   # The ID of the Recovery Services Vault.
      backup_policy_id    = azurerm_backup_policy_vm.this[rv_k].id          # The ID of the VM Backup Policy.
    }
  }
  description = "Map of Recovery Services Vault and Azure VM Backup Policy Resources"
}

output "depended_on_rsv" {
  value = null_resource.dependency_rsv.id
}
