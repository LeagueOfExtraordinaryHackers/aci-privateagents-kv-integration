#! /usr/bin/env bash
#
# Author: Andreas Heumaier <andreas.heumaier@microsoft.com>
#
#/ Usage: create_vg.sh
#
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail

readonly script_name=$(basename "${0}")
readonly script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
IFS=$'\t\n' # Split on newlines and tabs (but not on spaces)

# Global vars
ORG="https://dev.azure.com/cavertes"
PROJECT="VW_Sharing"
VG_NAME="TFBackend"

# Query the variable group used
vg_id() {
    az pipelines variable-group list --organization "${ORG}" --project "${PROJECT}" --query "[?name=='$VG_NAME']".id -o tsv
}
# Delete a variable group used by $VG_NAME
delete_vg() {
    az pipelines variable-group delete --organization "${ORG}" --project "${PROJECT}" --id "$(vg_id)" -y
}
# Create a variable group used by $VG_NAME
create_vg() {
    az pipelines variable-group create --authorize true --organization "$ORG" --project "${PROJECT}" --name "$(vg_id)" --variables dummy=dummy --query id -o tsv
}

# ReCreate a variable group used by $VG_NAME
recreate_vg() {
    delete_vg && create_vg
}

run_main() {
    command -v "az" >/dev/null || {
        echo "[ERROR]: az command not found."
        exit 1
    }
    #  Define local vars and populate with variables
    declare -A variable_groups=(
        [backendContainerName]=tfstate
        [backendStorageAccountName]="tfme"
        [backendStorageAccountSKU]="Standard_LRS"
        [backendStorageResourceGroupName]="storage"
        [location]="westeurope"
        [service_connection]="azuresc-alvozza"
    )

    # Ensure  sure we delete our previous VG
    recreate_vg

    #  Create variable-group variables defines in $variable_groups above
    for vg in "${!variable_groups[@]}"; do
        az pipelines variable-group variable create --organization "${ORG}" --project "${PROJECT}" --id $(vg_id) --name "${vg}" --value "${variable_groups[$vg]}"
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_main
fi
