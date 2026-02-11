#!/bin/bash

# Script de Backup Automático de Arquivos de Mapeamento
# Organiza os arquivos mapping.txt por versão para fácil recuperação

set -e

echo "🔍 Iniciando backup do arquivo de mapeamento..."

# Diretório base do projeto
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Ler versão do pubspec.yaml
VERSION=$(grep "^version:" "$PROJECT_DIR/pubspec.yaml" | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
VERSION_CODE=$(echo $VERSION | cut -d'+' -f2)

echo "📦 Versão detectada: $VERSION_NAME (código: $VERSION_CODE)"

# Diretório de backup (pode customizar este caminho)
BACKUP_DIR="$PROJECT_DIR/mapping-backups"
VERSION_DIR="$BACKUP_DIR/v${VERSION_NAME}_${VERSION_CODE}"

# Criar diretório de backup se não existir
mkdir -p "$VERSION_DIR"

# Caminhos dos arquivos
MAPPING_FILE="$PROJECT_DIR/build/app/outputs/mapping/release/mapping.txt"
AAB_FILE="$PROJECT_DIR/build/app/outputs/bundle/release/app-release.aab"

# Verificar se o arquivo de mapeamento existe
if [ ! -f "$MAPPING_FILE" ]; then
    echo "❌ Erro: Arquivo de mapeamento não encontrado em:"
    echo "   $MAPPING_FILE"
    echo ""
    echo "Execute 'flutter build appbundle --release' primeiro!"
    exit 1
fi

# Copiar arquivos
echo "📋 Copiando arquivos para: $VERSION_DIR"

# Copiar mapping.txt
cp "$MAPPING_FILE" "$VERSION_DIR/mapping.txt"
echo "✅ mapping.txt copiado"

# Copiar AAB se existir
if [ -f "$AAB_FILE" ]; then
    cp "$AAB_FILE" "$VERSION_DIR/app-release.aab"
    echo "✅ app-release.aab copiado"
fi

# Copiar outros arquivos úteis (opcionais)
if [ -f "$PROJECT_DIR/build/app/outputs/mapping/release/configuration.txt" ]; then
    cp "$PROJECT_DIR/build/app/outputs/mapping/release/configuration.txt" "$VERSION_DIR/"
fi

if [ -f "$PROJECT_DIR/build/app/outputs/mapping/release/resources.txt" ]; then
    cp "$PROJECT_DIR/build/app/outputs/mapping/release/resources.txt" "$VERSION_DIR/"
fi

# Criar arquivo de metadados
cat > "$VERSION_DIR/BUILD_INFO.txt" << EOF
Versão: $VERSION_NAME
Código da Versão: $VERSION_CODE
Data do Build: $(date '+%Y-%m-%d %H:%M:%S')
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "N/A")
Git Branch: $(git branch --show-current 2>/dev/null || echo "N/A")
EOF

echo "✅ Informações do build salvas em BUILD_INFO.txt"

# Estatísticas
MAPPING_SIZE=$(du -h "$VERSION_DIR/mapping.txt" | cut -f1)
echo ""
echo "✨ Backup concluído com sucesso!"
echo "📁 Localização: $VERSION_DIR"
echo "📊 Tamanho do mapping.txt: $MAPPING_SIZE"
echo ""
echo "🔐 IMPORTANTE: Mantenha esses arquivos em local seguro!"
echo "   Sem o mapping.txt, você não conseguirá decodificar crashes."
echo ""

# Listar todos os backups
echo "📚 Backups disponíveis:"
ls -1 "$BACKUP_DIR" | grep "^v" | tail -5

echo ""
echo "💡 Dica: Considere fazer backup deste diretório:"
echo "   $BACKUP_DIR"
echo "   em um serviço de nuvem (Google Drive, Dropbox, etc.)"
