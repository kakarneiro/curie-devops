# Roteiro do video - DevOps (3 minutos, 720p+, YouTube nao listado, com narracao)

Gravar a tela com o terminal (Git Bash ou Azure Cloud Shell) e o navegador lado a lado.
Antes de gravar: `az login` feito e `azure-deploy.sh` testado uma vez (a primeira execucao
demora mais por causa do build Maven na VM).

| Tempo | O que mostrar | O que falar |
|---|---|---|
| 0:00-0:20 | README do devops no GitHub, nomes e RMs | "Grupo CURIE, 2TDSPB. Vamos subir a CURIE API em container numa VM da Azure criada por Azure CLI." |
| 0:20-0:40 | `Dockerfile` aberto | Dois estagios: Maven compila, JRE executa. Credenciais so por variavel de ambiente. |
| 0:40-1:40 | Terminal: `./azure-deploy.sh` rodando | Narrar cada etapa conforme aparece: resource group, VM, porta 8080, Docker, build, run. Mostrar o IP publico impresso no final. |
| 1:40-2:10 | Portal Azure: resource group rg-curie com VM, disco, IP, NSG | "Recursos provisionados pelo script, nao pelo portal." |
| 2:10-2:40 | Navegador: `http://<IP-PUBLICO>:8080/swagger-ui.html` e um GET /api/escolas executado | "Aplicacao respondendo pelo IP publico da VM - nao e localhost." Opcional: `ssh curie@<IP>` + `docker ps`. |
| 2:40-3:00 | Terminal: `./azure-cleanup.sh` e `az group list` vazio | "Resource group apagado, nenhum recurso cobrando." Encerrar. |

Checklist (cada item e uma penalidade do professor):
- [ ] VM criada por Azure CLI aparece no video (-15 se nao)
- [ ] Script .sh aparece no repositorio (-15 se nao)
- [ ] Container rodando (docker ps) (-50 se nao)
- [ ] Aplicacao acessada pelo IP publico, nunca localhost (-100 se localhost)
- [ ] Exclusao do resource group mostrada (-5 se nao)
- [ ] Resolucao >= 720p, texto legivel, audio ou legendas
