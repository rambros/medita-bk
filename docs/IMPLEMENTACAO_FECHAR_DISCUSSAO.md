# Implementação: Fechar Discussão

## Resumo

Implementada funcionalidade que permite ao aluno marcar suas próprias threads de discussão como "fechadas" ou "resolvidas".

**Data da Implementação**: 2025-12-11

---

## 📋 Funcionalidades Implementadas

### 1. **Botão "Marcar como Resolvida"**
- ✅ Disponível apenas para o autor da discussão
- ✅ Visível quando a discussão está aberta
- ✅ Exibe diálogo de confirmação antes de fechar
- ✅ Localizado no AppBar como ícone de ação

### 2. **Botão "Reabrir Discussão"**
- ✅ Disponível apenas para o autor da discussão
- ✅ Visível quando a discussão está fechada
- ✅ Permite reabrir caso a solução não tenha funcionado
- ✅ Remove marcação de solução das respostas

### 3. **Estado Visual**
- ✅ Badge/ícone verde indicando discussão resolvida
- ✅ Banner superior com status "Discussão Resolvida"
- ✅ Mensagem informando quando foi fechada
- ✅ Status visual no card da discussão

### 4. **Notificações**
- ✅ Participantes notificados quando discussão é fechada
- ✅ Notificação enviada para todos que responderam
- ✅ Contador de notificações atualizado
- ✅ Navegação direta para a discussão

### 5. **Comportamento**
- ✅ Discussões fechadas não permitem novas respostas
- ✅ Status atualizado automaticamente via Stream
- ✅ Cache atualizado corretamente
- ✅ Integração com o sistema existente de marcar solução

---

## 🗄️ Alterações no Modelo de Dados

### Novos Campos em `DiscussaoModel`

```dart
// Campos de fechamento
final String? fechadaPor;        // ID do usuário que fechou
final DateTime? dataFechamento;  // Data/hora do fechamento
```

### Novos Métodos Helper

```dart
/// Verifica se o usuário pode fechar a discussão
bool podeFechar(String usuarioId) => isMinhaDiscussao(usuarioId) && !status.isFechada;

/// Verifica se o usuário pode reabrir a discussão
bool podeReabrir(String usuarioId) => isMinhaDiscussao(usuarioId) && status.isFechada;
```

---

## 📱 Arquivos Modificados

### 1. **Modelo** - `lib/domain/models/ead/discussao_model.dart`
- ✅ Adicionados campos `fechadaPor` e `dataFechamento`
- ✅ Atualizados métodos `fromMap`, `toMap` e `copyWith`
- ✅ Adicionados métodos `podeFechar()` e `podeReabrir()`

### 2. **Service** - `lib/data/services/comunicacao_service.dart`
- ✅ Adicionado método `fecharDiscussao()`
- ✅ Adicionado método `reabrirDiscussao()`
- ✅ Atualizado método `marcarComoSolucao()` para incluir campos de fechamento

### 3. **Repository** - `lib/data/repositories/comunicacao_repository.dart`
- ✅ Adicionado método `fecharDiscussao()`
- ✅ Adicionado método `reabrirDiscussao()`
- ✅ Implementada atualização de cache

### 4. **ViewModel** - `lib/ui/ead/discussoes/discussao_detail_page/view_model/discussao_detail_view_model.dart`
- ✅ Adicionado método `fecharDiscussao()`
- ✅ Adicionado método `reabrirDiscussao()`

### 5. **UI** - `lib/ui/ead/discussoes/discussao_detail_page/discussao_detail_page.dart`
- ✅ Adicionado botão de fechar no AppBar
- ✅ Adicionado botão de reabrir no AppBar
- ✅ Implementado diálogo de confirmação
- ✅ Adicionado banner visual de discussão fechada
- ✅ Implementada função `_buildBannerFechada()`
- ✅ Implementada função `_formatarData()`
- ✅ Feedback visual com SnackBar

### 6. **Notificações** - `lib/data/services/notificacao_ead_service.dart`
- ✅ Adicionado método `notificarDiscussaoFechada()`
- ✅ Envia notificações em batch para múltiplos destinatários
- ✅ Incrementa contadores de notificações
- ✅ Inclui dados de navegação para a discussão

---

## 🔄 Fluxo de Funcionamento

### Fechar Discussão

1. Usuário clica no ícone ✓ no AppBar
2. Sistema exibe diálogo de confirmação
3. Se confirmado:
   - Atualiza status para `fechada`
   - Registra `fechadaPor` com ID do usuário
   - Registra `dataFechamento` com timestamp atual
   - Atualiza `dataAtualizacao`
4. UI atualiza automaticamente via Stream
5. Exibe banner verde "Discussão Resolvida"
6. Input de resposta fica desabilitado

### Reabrir Discussão

1. Usuário clica no ícone ↻ no AppBar
2. Sistema reabre sem confirmação
3. Ações executadas:
   - Atualiza status para `respondida` ou `aberta`
   - Remove `fechadaPor` e `dataFechamento`
   - Desmarca respostas marcadas como solução
   - Atualiza `dataAtualizacao`
4. UI atualiza automaticamente via Stream
5. Banner de fechamento desaparece
6. Input de resposta fica habilitado

---

## 🎯 Regras de Negócio

1. **Apenas o autor** pode fechar ou reabrir sua própria discussão
2. **Discussão fechada** não aceita novas respostas
3. **Status automático** ao reabrir:
   - Se tem respostas → `respondida`
   - Se não tem respostas → `aberta`
4. **Marcar solução** também fecha a discussão automaticamente
5. **Reabrir** remove a marcação de solução das respostas

---

## 🔒 Segurança

### Validações no Service

```dart
// Verifica se o usuário é o autor antes de permitir
final discussao = await getDiscussaoById(discussaoId);
if (discussao == null || discussao.autorId != usuarioId) {
  debugPrint('Usuário não autorizado');
  return false;
}
```

### Firestore Security Rules (A implementar)

```javascript
// Permitir fechar apenas para o autor
allow update: if request.auth != null &&
  request.resource.data.status == 'fechada' &&
  resource.data.autorId == request.auth.uid;
```

---

## 📊 Estrutura no Firestore

### Collection: `discussoes/{discussaoId}`

```javascript
{
  id: string,
  titulo: string,
  conteudo: string,
  autorId: string,
  autorNome: string,
  status: string, // 'aberta', 'respondida', 'fechada'

  // Novos campos
  fechadaPor: string?,      // userId de quem fechou
  dataFechamento: timestamp?,

  // Campos existentes
  cursoId: string,
  dataCriacao: timestamp,
  dataAtualizacao: timestamp,
  totalRespostas: number
}
```

---

## ✅ Testes Manuais Sugeridos

1. **Fechar discussão sem respostas**
   - Criar nova discussão
   - Fechar imediatamente
   - Verificar status e visual

2. **Fechar discussão com respostas**
   - Criar discussão e adicionar respostas
   - Fechar discussão
   - Verificar que não aceita novas respostas

3. **Reabrir discussão**
   - Fechar uma discussão
   - Reabrir
   - Verificar que aceita novas respostas

4. **Marcar solução e reabrir**
   - Marcar uma resposta como solução
   - Verificar que fechou
   - Reabrir
   - Verificar que removeu a solução

5. **Permissões**
   - Tentar acessar discussão de outro usuário
   - Verificar que botões não aparecem

---

## 🚀 Próximos Passos (Opcional)

### Melhorias Futuras

1. **Notificações Adicionais**
   - ✅ Notificar participantes quando discussão for fechada (IMPLEMENTADO)
   - ⏳ Notificar quando discussão for reaberta (opcional)

2. **Filtros**
   - Adicionar filtro por status na lista de discussões
   - Mostrar apenas discussões abertas/fechadas
   - Ordenação por discussões sem solução

3. **Analytics**
   - Taxa de resolução de discussões
   - Tempo médio até resolução
   - Usuários mais ativos em resoluções

4. **Firestore Rules**
   - Implementar as regras de segurança sugeridas
   - Testar permissões no Firebase Console

---

## 📝 Notas Técnicas

- ✅ Compatível com a estrutura existente do Web Admin
- ✅ Usa Streams para atualização em tempo real
- ✅ Cache otimizado no Repository
- ✅ Código documentado com comentários
- ✅ Notificações implementadas e funcionais
- ✅ Batch write para performance em múltiplas notificações

---

**Implementado por**: Claude Code
**Baseado em**: [docs/FEATURE_FECHAR_DISCUSSAO.md](FEATURE_FECHAR_DISCUSSAO.md)
