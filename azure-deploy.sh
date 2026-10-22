#!/usr/bin/env bash
# =====================================================================
#  Projeto CURIE - Provisionamento na Azure via Azure CLI
#  Cria resource group, VM Ubuntu, abre portas, instala Docker,
#  clona o repositorio, constroi a imagem e sobe o container da API.
#
#  Uso:
#    ./azure-deploy.sh                      -> perfil demo (H2 em memoria)
#    ORACLE_USER=RM000000 ORACLE_PASSWORD=xxx ./azure-deploy.sh  -> Oracle FIAP
#
#  Pre-requisitos: az login feito; conta com credito (Azure for Students).
#  Grupo CURIE - 2TDSPB - Challenge FIAP 2026 / CTMSP
# =====================================================================
set -euo pipefail

RG="rg-curie"
LOCATION="brazilsouth"
VM="vm-curie"
VM_SIZE="Standard_B2s"            # 2 vCPU / 4 GB: suficiente para o build Maven
IMAGE="Ubuntu2204"
ADMIN="curie"
REPO="https://github.com/kakarneiro/curie-api.git"
APP_PORT=8080

ORACLE_USER="${ORACLE_USER:-}"
ORACLE_PASSWORD="${ORACLE_PASSWORD:-}"

echo "==> [1/6] Resource group $RG em $LOCATION"
az group create --name "$RG" --location "$LOCATION" --output table

echo "==> [2/6] VM $VM ($IMAGE, $VM_SIZE)"
az vm create \
  --resource-group "$RG" \
  --name "$VM" \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN" \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --nsg-rule SSH \
  --output table

echo "==> [3/6] Liberando porta $APP_PORT no NSG"
az vm open-port --resource-group "$RG" --name "$VM" --port "$APP_PORT" --priority 1010 --output none

PUBLIC_IP=$(az vm show --resource-group "$RG" --name "$VM" --show-details --query publicIps --output tsv)
echo "    IP publico: $PUBLIC_IP"

if [[ -n "$ORACLE_USER" && -n "$ORACLE_PASSWORD" ]]; then
  ENV_FLAGS="-e ORACLE_USER=$ORACLE_USER -e ORACLE_PASSWORD=$ORACLE_PASSWORD -e SPRING_PROFILES_ACTIVE=prod"
  echo "    Perfil: Oracle FIAP (usuario $ORACLE_USER)"
else
  ENV_FLAGS="-e SPRING_PROFILES_ACTIVE=demo"
  echo "    Perfil: demo (H2 em memoria)"
fi

echo "==> [4/6] Instalando Docker na VM"
az vm run-command invoke \
  --resource-group "$RG" --name "$VM" \
  --command-id RunShellScript \
  --scripts "curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker $ADMIN" \
  --output none

echo "==> [5/6] Clonando repositorio e construindo a imagem (pode levar ~3 min)"
az vm run-command invoke \
  --resource-group "$RG" --name "$VM" \
  --command-id RunShellScript \
  --scripts "rm -rf /opt/curie && git clone $REPO /opt/curie && cd /opt/curie && sudo docker build -t curie-api:1.0 ." \
  --query "value[0].message" --output tsv | tail -n 5

echo "==> [6/6] Subindo o container"
az vm run-command invoke \
  --resource-group "$RG" --name "$VM" \
  --command-id RunShellScript \
  --scripts "sudo docker rm -f curie-api 2>/dev/null; sudo docker run -d --name curie-api --restart unless-stopped -p $APP_PORT:8080 $ENV_FLAGS curie-api:1.0 && sleep 25 && sudo docker ps && curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:$APP_PORT/v3/api-docs" \
  --query "value[0].message" --output tsv | tail -n 8

echo
echo "====================================================================="
echo " CURIE API no ar:  http://$PUBLIC_IP:$APP_PORT/swagger-ui.html"
echo " SSH:              ssh $ADMIN@$PUBLIC_IP"
echo " Para apagar tudo: ./azure-cleanup.sh"
echo "====================================================================="
