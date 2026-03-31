#!/bin/bash

# Configuração da Versão
VERSION="1.0.0"

# Cores
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
NC='\033[0m'

ajuda() {
    echo -e "${VERDE}--- folder-sweep v$VERSION ---${NC}"
    echo "O folder-sweep é uma ferramenta para varrer e remover diretórios"
    echo "inchados, ajudando você a recuperar espaço em disco facilmente."
    echo ""
    echo "Uso: folder-sweep <nome_da_pasta> [opções]"
    echo ""
    echo "Argumentos:"
    echo "  nome_da_pasta   O nome da pasta que deseja varrer (ex: node_modules, dist, .cache)"
    echo ""
    echo "Opções:"
    echo "  -l    Apenas lista o caminho e o peso de cada pasta encontrada."
    echo "  -r    Remove as pastas e exibe o total de espaço liberado."
    echo "  -v    Exibe a versão atual do folder-sweep."
    echo "  -h    Exibe este menu de ajuda."
    echo ""
    echo "Exemplo: folder-sweep node_modules -r"
    exit 1
}

# Verifica se o primeiro argumento existe e não é uma flag ou se pediu versão
if [ "$1" == "-v" ]; then
    echo "folder-sweep versão $VERSION"
    exit 0
fi

if [ -z "$1" ] || [[ "$1" == -* ]]; then
    ajuda
fi

TARGET_DIR="$1"
shift 

processar() {
    local modo=$1
    local total_bytes=0
    
    echo -e "${AMARELO}Buscando por '$TARGET_DIR'...${NC}\n"

    while IFS= read -r dir; do
        tamanho_h=$(du -sh "$dir" 2>/dev/null | cut -f1)
        tamanho_b=$(du -sb "$dir" 2>/dev/null | cut -f1)
        
        total_bytes=$((total_bytes + tamanho_b))

        if [ "$modo" == "remove" ]; then
            echo -e "${VERMELHO}Varrendo (removendo):${NC} $dir ($tamanho_h)"
            rm -rf "$dir"
        else
            echo -e "${VERDE}Encontrado:${NC} $dir ($tamanho_h)"
        fi
    done < <(find . -type d -name "$TARGET_DIR" -prune)

    total_h=$(numfmt --to=iec-i --suffix=B $total_bytes 2>/dev/null || echo "$total_bytes bytes")
    
    echo -e "\n---------------------------------------"
    echo -e "Pasta alvo: ${AMARELO}$TARGET_DIR${NC}"
    if [ "$modo" == "remove" ]; then
        echo -e "${VERDE}Varredura concluída! Espaço total liberado: $total_h${NC}"
    else
        echo -e "${AMARELO}Espaço total ocupado por '$TARGET_DIR': $total_h${NC}"
    fi
}

while getopts "lrvh" opt; do
    case $opt in
        l) processar "lista" ;;
        r) processar "remove" ;;
        v) echo "folder-sweep versão $VERSION"; exit 0 ;;
        h) ajuda ;;
        *) ajuda ;;
    esac
done
