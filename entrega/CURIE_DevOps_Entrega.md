# Challenge FIAP 2026 — CTMSP / Marinha do Brasil
## DevOps Tools & Cloud Computing — Entrega 1º Sprint

**Projeto:** CURIE — "Um laboratório nuclear em cada escola por R$ 300"

### Integrantes

| Nome | RM | Turma |
|---|---|---|
| Matheus Carneiro Maciel | 567753 | 2TDSPB |
| Murilo Marques | 568224 | 2TDSPB |
| Paulo Henrique da Silva Kian | 563343 | 2TDSPB |

### Links

- **Repositório DevOps (scripts, arquitetura, README):** https://github.com/kakarneiro/curie-devops
- **Repositório da aplicação (código + Dockerfile):** https://github.com/kakarneiro/curie-api
- **Vídeo no YouTube (não listado):** COLOQUE-O-LINK-AQUI

### Conteúdo do repositório

- `Dockerfile` — imagem multi-stage da CURIE API (Java 17 / Spring Boot)
- `azure-deploy.sh` — Azure CLI: resource group, VM Ubuntu, NSG, Docker, build e execução do container
- `azure-cleanup.sh` — exclusão do resource group
- `docs/arquitetura-curie-devops.drawio` e `.png` — arquitetura com ícones oficiais Azure/Docker
- `README.md` — instruções, comandos e o texto "Como Docker e Cloud Computing podem ser utilizados na solução"
