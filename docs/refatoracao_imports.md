# Plano de Refatoração: Migração de Imports Relativos para Absolutos

## 1. Contexto e Motivação

O projeto atualmente contém **124 imports relativos** (usando `../`) que precisam ser migrados para imports absolutos usando o prefixo `package:medita_b_k/`.

### Benefícios da migração:
- **Clareza**: Imports absolutos deixam claro de onde vem cada dependência
- **Manutenção**: Facilita refatorações e movimentação de arquivos
- **Consistência**: Alinha com as boas práticas do Flutter e Dart
- **Padrão do projeto**: Conforme especificado no `flutter_standards.md` linha 183

### Estado atual:
- ✅ Alguns arquivos já usam imports absolutos (ex: `/main.dart`)
- ⚠️ Muitos arquivos ainda usam imports relativos (ex: `catalogo_cursos_page.dart`)
- 📦 Nome do package: `medita_b_k`

---

## 2. Padrões de Import

### ❌ Formato atual (relativos):
```dart
import '../../../data/repositories/auth_repository.dart';
import '../../../routing/ead_routes.dart';
import '../../core/theme/app_theme.dart';
```

### ✅ Formato desejado (absolutos):
```dart
import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
```

### 🔍 Nota sobre imports já absolutos:
Alguns arquivos usam `/` no início (ex: `/core/services/audio_service.dart`). Estes também precisam ser convertidos para o formato `package:medita_b_k/`.

---

## 3. Escopo da Refatoração

### Arquivos afetados:
- **Total estimado**: ~124 imports relativos distribuídos em múltiplos arquivos
- **Diretórios principais**:
  - `lib/ui/` (interface de usuário)
  - `lib/data/` (repositories e services)
  - `lib/domain/` (models)
  - `lib/core/` (services e utilities)
  - `lib/routing/` (rotas)

### Tipos de imports a migrar:
1. ✅ Imports relativos com `../`
2. ✅ Imports absolutos com `/` (sem package prefix)
3. ❌ Não modificar: imports de pacotes externos (ex: `package:flutter/material.dart`)
4. ❌ Não modificar: imports do Dart SDK (ex: `dart:async`)

---

## 4. Estratégia de Execução

### Fase 1: Análise e Mapeamento (PREPARAÇÃO)
1. **Listar todos os arquivos com imports relativos**
   - Usar grep para encontrar padrões `import '../` e `import '/`
   - Gerar lista completa de arquivos afetados
   - Categorizar por módulo/feature

2. **Identificar padrões de imports**
   - Documentar os tipos de imports mais comuns
   - Identificar casos especiais (index.dart, exports, etc.)

### Fase 2: Criação de Scripts de Migração (AUTOMAÇÃO)
3. **Desenvolver script de conversão**
   - Script Dart ou Shell para automatizar a conversão
   - Validar conversões antes de aplicar
   - Manter backup dos arquivos originais

4. **Definir regras de conversão**
   - `../` → calcular caminho absoluto a partir de lib/
   - `/` no início → adicionar `package:medita_b_k`
   - Preservar imports de pacotes externos

### Fase 3: Migração Incremental por Módulo (EXECUÇÃO)
5. **Migrar módulo por módulo**
   - Começar por módulos menores/mais isolados
   - Ordem sugerida:
     1. `lib/domain/models/` (poucos imports, baixo acoplamento)
     2. `lib/data/services/` (camada de infraestrutura)
     3. `lib/data/repositories/` (camada de dados)
     4. `lib/core/` (utilities e services core)
     5. `lib/ui/core/` (widgets e themes compartilhados)
     6. `lib/ui/<features>/` (features específicas)
     7. `lib/routing/` (configuração de rotas)
     8. `lib/main.dart` e entry points

6. **Validação após cada módulo**
   - Executar `flutter analyze` após cada módulo
   - Corrigir erros imediatamente
   - Executar `flutter test` se houver testes

### Fase 4: Casos Especiais (REFINAMENTO)
7. **Tratar arquivos index.dart**
   - Revisar exports em arquivos `index.dart`
   - Garantir que re-exports funcionem corretamente

8. **Revisar imports circulares**
   - Identificar e resolver dependências circulares
   - Refatorar se necessário

### Fase 5: Validação Final (GARANTIA DE QUALIDADE)
9. **Testes completos**
   - `flutter clean`
   - `flutter pub get`
   - `flutter analyze` (zero erros)
   - `flutter test` (todos os testes passando)
   - Build de debug: `flutter build apk --debug`
   - Build de release: `flutter build apk --release` (iOS: `flutter build ios`)

10. **Validação manual**
    - Verificar que app inicia sem erros
    - Navegar entre principais telas
    - Testar funcionalidades críticas

---

## 5. Plano de Contingência

### Rollback rápido:
- Manter commits atômicos por módulo
- Possibilidade de reverter módulo específico
- Backup antes de iniciar refatoração

### Tratamento de erros:
- Documentar erros encontrados
- Resolver problemas de dependência circular
- Atualizar documentação se necessário

---

## 6. Checklist de Execução

### Preparação:
- [ ] Garantir que projeto está em branch separada
- [ ] Commit de todo trabalho pendente
- [ ] Criar branch: `refactor/absolute-imports`
- [ ] Fazer backup completo do projeto

### Execução:
- [ ] Fase 1: Análise completa dos imports
- [ ] Fase 2: Script de conversão criado e testado
- [ ] Fase 3: Migração módulo a módulo
  - [ ] `lib/domain/models/`
  - [ ] `lib/data/services/`
  - [ ] `lib/data/repositories/`
  - [ ] `lib/core/`
  - [ ] `lib/ui/core/`
  - [ ] `lib/ui/<features>/`
  - [ ] `lib/routing/`
  - [ ] `lib/main.dart`
- [ ] Fase 4: Casos especiais resolvidos
- [ ] Fase 5: Validação completa

### Finalização:
- [ ] `flutter analyze` sem erros
- [ ] `flutter test` 100% passando
- [ ] Build debug funcionando
- [ ] Build release funcionando
- [ ] App testado manualmente
- [ ] Commit final com mensagem descritiva
- [ ] PR criado para review

---

## 7. Comandos Úteis

```bash
# Listar todos os imports relativos
grep -r "^import '\.\." lib --include="*.dart"

# Listar todos os imports absolutos com /
grep -r "^import '/" lib --include="*.dart"

# Contar imports relativos por diretório
find lib -name "*.dart" -exec grep -l "^import '\.\." {} \; | cut -d'/' -f1-3 | sort | uniq -c

# Executar análise
flutter analyze

# Limpar e rebuildar
flutter clean && flutter pub get

# Executar testes
flutter test
```

---

## 8. Estimativa de Esforço

- **Análise**: 30 minutos
- **Script de conversão**: 1 hora
- **Migração**: 2-3 horas (dependendo do número de arquivos)
- **Testes e validação**: 1 hora
- **Buffer para problemas**: 1 hora
- **Total estimado**: 5-6 horas

---

## 9. Critérios de Sucesso

✅ Zero imports relativos (`../`) no código
✅ Zero imports absolutos sem package prefix (`/`)
✅ `flutter analyze` sem warnings/erros
✅ Todos os testes passando
✅ App compila e executa normalmente
✅ Código mais limpo e manutenível

---

## 10. Próximos Passos

Após aprovação deste plano:
1. Criar branch `refactor/absolute-imports`
2. Iniciar Fase 1: Análise
3. Executar refatoração seguindo o plano
4. Submeter PR para revisão
