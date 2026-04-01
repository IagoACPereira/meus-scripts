#!/bin/bash

# Cores para facilitar a leitura
VERDE='\033[0;32m'
NC='\033[0m' # Sem cor

echo -e "${VERDE}--- Iniciando Atualização Completa do Sistema ---${NC}"

# 1. Atualiza a lista de repositórios
echo -e "\n${VERDE}[1/5] Atualizando repositórios...${NC}"
sudo apt update

# 2. Atualiza os pacotes do sistema e resolve dependências
echo -e "\n${VERDE}[2/5] Instalando atualizações de pacotes...${NC}"
sudo apt full-upgrade -y

# 3. Atualiza aplicativos Flatpak (muito usados no Mint)
echo -e "\n${VERDE}[3/5] Atualizando Flatpaks...${NC}"
flatpak update -y

# 4. Limpa pacotes desnecessários (sobras de kernels antigos e cache)
echo -e "\n${VERDE}[4/5] Limpando o sistema...${NC}"
sudo apt autoremove -y
sudo apt autoclean

# 5. Atualiza o banco de dados do comando 'locate' (opcional, mas útil)
echo -e "\n${VERDE}[5/5] Atualizando índice de arquivos...${NC}"
sudo updatedb

echo -e "\n${VERDE}--- Sistema Atualizado com Sucesso! ---${NC}"