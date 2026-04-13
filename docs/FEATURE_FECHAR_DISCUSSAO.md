# Feature: Permitir Aluno Fechar/Concluir Thread de Discussão

## Objetivo

Permitir que alunos marquem suas próprias threads de discussão como "fechadas" ou "resolvidas" quando obtiverem a resposta que precisavam.

---

## 📋 Requisitos

### Funcionalidades

1. **Botão "Marcar como Resolvida"**
   - Disponível apenas para o autor da discussão
   - Visível quando a discussão está aberta
   - Exibe confirmação antes de fechar

2. **Estado Visual**
   - Badge/ícone indicando discussão resolvida
   - Cor diferenciada para discussões fechadas
   - Mensagem de quem fechou e quando

3. **Notificações**
   - Notificar participantes quando discussão for fechada
   - Tipo: `discussaoResolvida` (já existe no enum)

4. **Reabertura** (opcional)
   - Apenas autor pode reabrir
   - Caso a solução não tenha funcionado

---

## 🗄️ Modelo de Dados (Firestore)

### Collection: `discussoes` ou `forum_threads`

```javascript
{
  id: string,
  titulo: string,
  conteudo: string,
  autorId: string,
  autorNome: string,
  dataCriacao: timestamp,
  dataAtualizacao: timestamp,

  // NOVOS CAMPOS
  status: string, // 'aberta', 'resolvida', 'fechada'
  fechadaPor: string?, // userId de quem fechou
  dataFechamento: timestamp?,
  respostaId: string?, // ID da resposta marcada como solução (se houver)

  // Campos existentes
  cursoId: string?,
  moduloId: string?,
  tags: string[],
  visualizacoes: number,
  respostasCount: number
}
```

### Subcollection: `discussoes/{discussaoId}/respostas`

```javascript
{
  id: string,
  conteudo: string,
  autorId: string,
  autorNome: string,
  dataCriacao: timestamp,

  // NOVO CAMPO
  isSolucao: boolean, // Marcada como solução pelo autor da discussão
  curtidas: number
}
```

---

## 📱 Implementação Mobile (Flutter)

### 1. Atualizar Modelo de Discussão

**Arquivo**: `lib/domain/models/discussao_model.dart`

```dart
enum StatusDiscussao {
  aberta('aberta', 'Aberta'),
  resolvida('resolvida', 'Resolvida'),
  fechada('fechada', 'Fechada');

  final String value;
  final String label;
  const StatusDiscussao(this.value, this.label);
}

class DiscussaoModel {
  final String id;
  final String titulo;
  final String conteudo;
  final String autorId;
  final String autorNome;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  // Novos campos
  final StatusDiscussao status;
  final String? fechadaPor;
  final DateTime? dataFechamento;
  final String? respostaIdSolucao;

  // Campos existentes
  final String? cursoId;
  final List<String> tags;
  final int visualizacoes;
  final int respostasCount;

  const DiscussaoModel({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.autorId,
    required this.autorNome,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.status = StatusDiscussao.aberta,
    this.fechadaPor,
    this.dataFechamento,
    this.respostaIdSolucao,
    this.cursoId,
    this.tags = const [],
    this.visualizacoes = 0,
    this.respostasCount = 0,
  });

  // Helpers
  bool get isResolvida => status == StatusDiscussao.resolvida;
  bool get isFechada => status == StatusDiscussao.fechada;
  bool get isAberta => status == StatusDiscussao.aberta;
  bool podeFechar(String userId) => autorId == userId && isAberta;
  bool podeReabrir(String userId) => autorId == userId && (isResolvida || isFechada);
}
```

### 2. Atualizar Repository

**Arquivo**: `lib/data/repositories/discussoes_repository.dart`

```dart
class DiscussoesRepository {
  final FirebaseFirestore _firestore;

  /// Marca discussão como resolvida
  Future<void> marcarComoResolvida({
    required String discussaoId,
    required String userId,
    String? respostaIdSolucao,
  }) async {
    final doc = _firestore.collection('discussoes').doc(discussaoId);

    await doc.update({
      'status': 'resolvida',
      'fechadaPor': userId,
      'dataFechamento': FieldValue.serverTimestamp(),
      if (respostaIdSolucao != null) 'respostaIdSolucao': respostaIdSolucao,
      'dataAtualizacao': FieldValue.serverTimestamp(),
    });

    // Criar notificação para participantes
    await _notificarParticipantes(discussaoId, userId);
  }

  /// Reabrir discussão
  Future<void> reabrirDiscussao({
    required String discussaoId,
    required String userId,
  }) async {
    final doc = _firestore.collection('discussoes').doc(discussaoId);

    await doc.update({
      'status': 'aberta',
      'fechadaPor': null,
      'dataFechamento': null,
      'respostaIdSolucao': null,
      'dataAtualizacao': FieldValue.serverTimestamp(),
    });
  }

  /// Marcar resposta como solução
  Future<void> marcarRespostaComoSolucao({
    required String discussaoId,
    required String respostaId,
    required String userId,
  }) async {
    final batch = _firestore.batch();

    // Atualizar discussão
    batch.update(
      _firestore.collection('discussoes').doc(discussaoId),
      {
        'status': 'resolvida',
        'fechadaPor': userId,
        'dataFechamento': FieldValue.serverTimestamp(),
        'respostaIdSolucao': respostaId,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      },
    );

    // Marcar resposta
    batch.update(
      _firestore
          .collection('discussoes')
          .doc(discussaoId)
          .collection('respostas')
          .doc(respostaId),
      {'isSolucao': true},
    );

    await batch.commit();

    // Notificar autor da resposta
    await _notificarRespostaSolucao(discussaoId, respostaId, userId);
  }

  Future<void> _notificarParticipantes(String discussaoId, String userId) async {
    // Buscar discussão
    final discussaoDoc = await _firestore.collection('discussoes').doc(discussaoId).get();
    final discussao = discussaoDoc.data()!;

    // Buscar participantes únicos (quem respondeu)
    final respostasSnapshot = await _firestore
        .collection('discussoes')
        .doc(discussaoId)
        .collection('respostas')
        .get();

    final participantes = respostasSnapshot.docs
        .map((doc) => doc.data()['autorId'] as String)
        .where((id) => id != userId) // Não notificar quem fechou
        .toSet()
        .toList();

    if (participantes.isEmpty) return;

    // Criar notificação
    await _firestore.collection('notifications').add({
      'titulo': 'Discussão Resolvida',
      'conteudo': 'A discussão "${discussao['titulo']}" foi marcada como resolvida',
      'tipo': 'discussao_resolvida',
      'destinatarios': participantes,
      'dataCriacao': FieldValue.serverTimestamp(),
      'navegacao': {
        'tipo': 'discussao',
        'id': discussaoId,
        'dados': {
          'discussaoId': discussaoId,
          'titulo': discussao['titulo'],
        },
      },
    });
  }

  Future<void> _notificarRespostaSolucao(
    String discussaoId,
    String respostaId,
    String userId,
  ) async {
    // Buscar resposta
    final respostaDoc = await _firestore
        .collection('discussoes')
        .doc(discussaoId)
        .collection('respostas')
        .doc(respostaId)
        .get();

    final resposta = respostaDoc.data()!;
    final autorRespostaId = resposta['autorId'] as String;

    if (autorRespostaId == userId) return; // Não notificar a si mesmo

    // Buscar discussão
    final discussaoDoc = await _firestore.collection('discussoes').doc(discussaoId).get();
    final discussao = discussaoDoc.data()!;

    // Criar notificação
    await _firestore.collection('notifications').add({
      'titulo': 'Sua Resposta foi Marcada como Solução! 🎉',
      'conteudo': 'Sua resposta em "${discussao['titulo']}" foi marcada como solução',
      'tipo': 'resposta_solucao',
      'destinatarios': [autorRespostaId],
      'dataCriacao': FieldValue.serverTimestamp(),
      'navegacao': {
        'tipo': 'discussao',
        'id': discussaoId,
        'dados': {
          'discussaoId': discussaoId,
          'respostaId': respostaId,
        },
      },
    });
  }
}
```

### 3. UI - Widget do Card de Discussão

**Arquivo**: `lib/ui/discussoes/widgets/discussao_card.dart`

```dart
class DiscussaoCard extends StatelessWidget {
  final DiscussaoModel discussao;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      discussao.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  // Badge de status
                  if (discussao.isResolvida || discussao.isFechada)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: discussao.isResolvida
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: discussao.isResolvida
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            discussao.isResolvida
                                ? Icons.check_circle_outline
                                : Icons.lock_outline,
                            size: 14,
                            color: discussao.isResolvida
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            discussao.status.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: discussao.isResolvida
                                  ? Colors.green
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                discussao.conteudo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(discussao.autorNome, style: TextStyle(fontSize: 12)),
                  const Spacer(),
                  Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${discussao.respostasCount}'),
                  const SizedBox(width: 12),
                  Icon(Icons.visibility_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${discussao.visualizacoes}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 4. UI - Página de Detalhes da Discussão

**Arquivo**: `lib/ui/discussoes/discussao_detalhes_page.dart`

```dart
class DiscussaoDetalhesPage extends StatelessWidget {
  final String discussaoId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DiscussaoModel>(
      stream: context.read<DiscussoesRepository>().streamDiscussao(discussaoId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final discussao = snapshot.data!;
        final podeFechar = discussao.podeFechar(currentUserId);
        final podeReabrir = discussao.podeReabrir(currentUserId);

        return Scaffold(
          appBar: AppBar(
            title: Text('Discussão'),
            actions: [
              // Botão de marcar como resolvida
              if (podeFechar)
                IconButton(
                  icon: Icon(Icons.check_circle_outline),
                  tooltip: 'Marcar como resolvida',
                  onPressed: () => _mostrarDialogFechar(context, discussao),
                ),
              // Botão de reabrir
              if (podeReabrir)
                IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Reabrir discussão',
                  onPressed: () => _reabrirDiscussao(context, discussao),
                ),
            ],
          ),
          body: Column(
            children: [
              // Cabeçalho da discussão
              _buildHeader(discussao),

              // Banner se estiver resolvida
              if (discussao.isResolvida || discussao.isFechada)
                _buildBannerResolvida(discussao),

              // Lista de respostas
              Expanded(
                child: _buildListaRespostas(discussao, currentUserId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerResolvida(DiscussaoModel discussao) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.green.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discussão Resolvida',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
                if (discussao.dataFechamento != null)
                  Text(
                    'Fechada em ${_formatarData(discussao.dataFechamento!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogFechar(
    BuildContext context,
    DiscussaoModel discussao,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Marcar como Resolvida'),
        content: Text(
          'Esta discussão será marcada como resolvida. '
          'Outros usuários poderão ver que você encontrou a resposta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: Icon(Icons.check),
            label: Text('Marcar como Resolvida'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await context.read<DiscussoesRepository>().marcarComoResolvida(
          discussaoId: discussao.id,
          userId: FirebaseAuth.instance.currentUser!.uid,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Discussão marcada como resolvida!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _reabrirDiscussao(
    BuildContext context,
    DiscussaoModel discussao,
  ) async {
    try {
      await context.read<DiscussoesRepository>().reabrirDiscussao(
        discussaoId: discussao.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Discussão reaberta!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }
}
```

### 5. UI - Card de Resposta (com opção de marcar como solução)

```dart
class RespostaCard extends StatelessWidget {
  final RespostaModel resposta;
  final bool isAutorDiscussao;
  final bool discussaoAberta;
  final VoidCallback? onMarcarComoSolucao;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: resposta.isSolucao
          ? Colors.green.withOpacity(0.05)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              children: [
                CircleAvatar(
                  child: Text(resposta.autorNome[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resposta.autorNome,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _formatarData(resposta.dataCriacao),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Badge de solução
                if (resposta.isSolucao)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Solução',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Conteúdo
            Text(resposta.conteudo),

            // Ações
            if (isAutorDiscussao && discussaoAberta && !resposta.isSolucao)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton.icon(
                  onPressed: onMarcarComoSolucao,
                  icon: Icon(Icons.check_circle_outline, size: 18),
                  label: Text('Marcar como Solução'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔒 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /discussoes/{discussaoId} {
      // Permitir fechar apenas para o autor
      allow update: if request.auth != null &&
                       request.resource.data.status in ['resolvida', 'fechada'] &&
                       resource.data.autorId == request.auth.uid;

      match /respostas/{respostaId} {
        // Permitir marcar como solução apenas para autor da discussão
        allow update: if request.auth != null &&
                         request.resource.data.isSolucao == true &&
                         get(/databases/$(database)/documents/discussoes/$(discussaoId)).data.autorId == request.auth.uid;
      }
    }
  }
}
```

---

## ✅ Checklist de Implementação

### Backend (Firestore)
- [ ] Adicionar campos `status`, `fechadaPor`, `dataFechamento` à collection `discussoes`
- [ ] Adicionar campo `isSolucao` às respostas
- [ ] Atualizar Security Rules
- [ ] Criar índices necessários

### Mobile
- [ ] Criar enum `StatusDiscussao`
- [ ] Atualizar modelo `DiscussaoModel`
- [ ] Atualizar modelo `RespostaModel`
- [ ] Implementar métodos no repository
- [ ] Atualizar UI dos cards de discussão
- [ ] Adicionar botões de fechar/reabrir
- [ ] Implementar marcar resposta como solução
- [ ] Criar notificações quando discussão for fechada

### Web Admin (opcional)
- [ ] Permitir moderadores fecharem discussões
- [ ] Dashboard com estatísticas de discussões resolvidas

---

## 🎨 Melhorias Futuras

1. **Gamificação**
   - Dar pontos ao autor da resposta marcada como solução
   - Badge "Solucionador" para quem tem mais respostas marcadas como solução

2. **Filtros**
   - Filtrar discussões por status (abertas/resolvidas/fechadas)
   - Ordenar por discussões sem solução

3. **Analytics**
   - Taxa de resolução de discussões
   - Tempo médio até resolução
   - Usuários mais úteis (mais soluções)

---

**Criado em**: 2025-12-11
**Status**: Pronto para implementação
