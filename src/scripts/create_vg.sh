#! /usr/bin/env bash
#
# Author: Andreas Heumaier <andreas.heumaier@microsoft.com>
#
#/ Usage: create_vg.sh {ORG} {PROJECT}
#

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
# set -o nounset
# don't hide errors within pipes
set -o pipefail

readonly script_name=$(basename "${0}")
readonly script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
IFS=$'\t\n' # Split on newlines and tabs (but not on spaces)

# Global vars
ORG="${1:-"https://dev.azure.com/cavertes"}"
PROJECT="${2:-"VW_Sharing"}"
VG_NAME="${3:-"TFBackend"}"

# Query the variable group ID used with name $VG_NAME
get_vg_id() {
    az pipelines variable-group list --organization "${ORG}" --project "${PROJECT}" --query "[?name=='${VG_NAME}']".id -o tsv --only-show-errors
}

# Delete the variable group defined by $vg_id
delete_vg() {
    local vg_id=$1
    az pipelines variable-group delete --organization "${ORG}" --project "${PROJECT}" --id "${vg_id}" --yes --only-show-errors --output none
}

# Create a variable group used by $VG_NAME
create_vg() {
    az pipelines variable-group create --authorize true --organization "$ORG" --project "${PROJECT}" --name "${VG_NAME}" --variables dummy=dummy --query id -o tsv --only-show-errors
}

# ReCreate a variable group used by $VG_NAME
recreate_vg() {
    local vg_id=$(get_vg_id)
    if [[ "${vg_id}" ]]; then
        delete_vg "${vg_id}"
    fi
    create_vg
}

# Create variable-group variables defines in $variable_groups above
set_vg_variables() {
    local vg_id=$1
    for vg in "${!variable_groups[@]}"; do
        az pipelines variable-group variable create \
        --organization "${ORG}" \
        --project "${PROJECT}" \
        --id "$vg_id" \
        --name "${vg}" \
        --value "${variable_groups[$vg]}" \
        --only-show-errors \
        --output none
    done
}

run_main() {
    # Ensure az command exists
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

    # Create variable-group variables defined in $variable_groups above
    set_vg_variables $(get_vg_id)
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_main
fi
