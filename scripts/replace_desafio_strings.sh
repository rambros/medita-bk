#!/bin/bash

# Script para substituir strings hardcoded pelas constantes em todos os arquivos do módulo desafio

# Diretório base
BASE_DIR="/Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk/lib/ui/desafio"

# Lista de arquivos que contêm 'Desafio 21 dias'
FILES=(
  "completou_brasao_page/completou_brasao_page.dart"
  "completou_mandala_page/completou_mandala_page.dart"
  "visualizar_premio_page/visualizar_premio_page.dart"
  "completou_meditacao_page/completou_meditacao_page.dart"
  "conquistas_page/conquistas_page.dart"
  "home_desafio_page/home_desafio_page.dart"
  "lista_etapas_page/lista_etapas_page.dart"
  "desafio_onboarding_page/desafio_onboarding_page.dart"
  "diario_meditacao_page/diario_meditacao_page.dart"
  "diario_detalhes_page/diario_detalhes_page.dart"
)

echo "🔄 Iniciando substituição de strings por constantes..."
echo ""

for file in "${FILES[@]}"; do
  FULL_PATH="$BASE_DIR/$file"
  
  if [ -f "$FULL_PATH" ]; then
    echo "📝 Processando: $file"
    
    # Verifica se já tem o import
    if ! grep -q "import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';" "$FULL_PATH"; then
      echo "  ➕ Adicionando import..."
      # Adiciona o import após os outros imports do desafio
      sed -i '' "/import 'package:medita_bk\/ui\/desafio\//a\\
import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';
" "$FULL_PATH"
    fi
    
    # Substitui a string 'Desafio 21 dias' pela constante
    echo "  🔄 Substituindo strings..."
    sed -i '' "s/'Desafio 21 dias'/DesafioStrings.desafioTitle/g" "$FULL_PATH"
    
    echo "  ✅ Concluído!"
  else
    echo "  ⚠️  Arquivo não encontrado: $FULL_PATH"
  fi
  echo ""
done

echo "✅ Substituição concluída!"
