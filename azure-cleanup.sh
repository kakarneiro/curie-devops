#!/usr/bin/env bash
# Projeto CURIE - remove TODOS os recursos criados (resource group inteiro)
set -euo pipefail
RG="rg-curie"
echo "==> Apagando resource group $RG (VM, disco, IP, NSG, VNet)..."
az group delete --name "$RG" --yes
echo "==> Conferindo que nao sobrou nada:"
az group list --query "[?name=='$RG']" --output table
echo "==> Concluido. Nenhum recurso cobrando."
