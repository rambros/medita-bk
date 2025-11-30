# Plano de Implementação - Módulo EAD Mobile

> **Projeto:** MeditaBK Mobile
> **Data:** Novembro 2024
> **Baseado em:** Módulo EAD Web Admin + lib_sample

---

## 1. Análise Comparativa

### 1.1 Estrutura de Dados (Web Admin → Mobile)

| Web Admin | Mobile | Observações |
|-----------|--------|-------------|
| `CursoCompletoModel` | `CursoModel` | Simplificar para consumo |
| `AulaCompletaModel` | `AulaModel` | Equivalente a `Section` do sample |
| `TopicoCompletoModel` | `TopicoModel` | Equivalente a `Lesson` do sample |
| `InscricaoCursoModel` | `InscricaoCursoModel` | **Idêntico** - chave para progresso |
| `ProgressoCursoModel` | `ProgressoCursoModel` | **Idêntico** |
| `QuizQuestionModel` | `QuizQuestionModel` | **Idêntico** |

### 1.2 Mapeamento de Terminologia

| Web Admin | lib_sample | MeditaBK Mobile |
|-----------|------------|-----------------|
| Curso | Course | Curso |
| Aula | Section | Aula (módulo/capítulo) |
| Tópico | Lesson | Tópico (conteúdo individual) |
| Inscrição | Enrollment | Inscrição |
| Quiz | Quiz | Quiz |

---

## 2. Arquitetura Mobile

### 2.1 Estrutura de Pastas

```text
lib/
  ui/
    ead/
      ead_home_page/                    # Home do EAD
        ead_home_page.dart
        view_model/
          ead_home_view_model.dart
        widgets/
          curso_destaque_card.dart
          cursos_em_andamento_section.dart
      
      catalogo_cursos_page/             # Lista de cursos disponíveis
        catalogo_cursos_page.dart
        view_model/
          catalogo_cursos_view_model.dart
        widgets/
          curso_card.dart
          filtro_cursos_dialog.dart
      
      curso_detalhes_page/              # Detalhes + currículo do curso
        curso_detalhes_page.dart
        view_model/
          curso_detalhes_view_model.dart
        widgets/
          curso_info_header.dart
          curriculo_section.dart
          aula_tile.dart
          topico_tile.dart
          inscricao_button.dart
      
      meus_cursos_page/                 # Cursos do aluno
        meus_cursos_page.dart
        view_model/
          meus_cursos_view_model.dart
        widgets/
          meu_curso_card.dart
          progresso_indicator.dart
      
      player_topico_page/               # Player de conteúdo
        player_topico_page.dart
        view_model/
          player_topico_view_model.dart
        widgets/
          video_player_widget.dart
          texto_content_widget.dart
          audio_player_widget.dart
          mark_complete_button.dart
          navegacao_topicos.dart
      
      quiz_page/                        # Quiz de avaliação
        quiz_page.dart
        view_model/
          quiz_view_model.dart
        widgets/
          question_tile.dart
          option_tile.dart
          quiz_result_dialog.dart
      
      certificado_page/                 # Visualização de certificado
        certificado_page.dart
        view_model/
          certificado_view_model.dart
      
      widgets/                          # Widgets compartilhados EAD
        progresso_bar.dart
        duracao_badge.dart
        status_badge.dart
        empty_cursos_widget.dart
  
  domain/
    models/
      ead/
        curso_model.dart               # Model simplificado para mobile
        aula_model.dart
        topico_model.dart
        inscricao_curso_model.dart     # Idêntico ao web
        progresso_curso_model.dart     # Idêntico ao web
        quiz_question_model.dart
        ead_enums.dart
  
  data/
    repositories/
      ead_repository.dart              # Repository principal EAD
    
    services/
      ead_service.dart                 # Serviço Firebase EAD
```

### 2.2 Hierarquia de Dados

```
Curso (cursos/)
  ├── Aulas (cursos/{cursoId}/aulas/)
  │     └── Tópicos (cursos/{cursoId}/aulas/{aulaId}/topicos/)
  │           └── Quiz Questions (inline ou subcollection)
  │
  └── Inscrições (inscricoes_cursos/)
        └── Progresso (embedded document)
```

---

## 3. Features a Implementar

### Fase 1 - Core (MVP)
| # | Feature | Prioridade | Complexidade | Status |
|---|---------|------------|--------------|--------|
| 1.1 | Domain Models EAD | Alta | Baixa | ⬜ Pendente |
| 1.2 | EAD Repository | Alta | Média | ⬜ Pendente |
| 1.3 | Catálogo de Cursos | Alta | Média | ⬜ Pendente |
| 1.4 | Detalhes do Curso | Alta | Média | ⬜ Pendente |
| 1.5 | Inscrição em Curso | Alta | Baixa | ⬜ Pendente |
| 1.6 | Meus Cursos | Alta | Média | ⬜ Pendente |

### Fase 2 - Player & Progresso
| # | Feature | Prioridade | Complexidade | Status |
|---|---------|------------|--------------|--------|
| 2.1 | Player de Vídeo | Alta | Alta | ⬜ Pendente |
| 2.2 | Player de Áudio | Média | Média | ⬜ Pendente |
| 2.3 | Conteúdo Texto/HTML | Alta | Baixa | ⬜ Pendente |
| 2.4 | Marcar como Concluído | Alta | Média | ⬜ Pendente |
| 2.5 | Tracking de Progresso | Alta | Média | ⬜ Pendente |
| 2.6 | Navegação entre Tópicos | Alta | Média | ⬜ Pendente |

### Fase 3 - Quiz & Certificado
| # | Feature | Prioridade | Complexidade | Status |
|---|---------|------------|--------------|--------|
| 3.1 | Quiz de Avaliação | Média | Alta | ⬜ Pendente |
| 3.2 | Resultado do Quiz | Média | Média | ⬜ Pendente |
| 3.3 | Certificado de Conclusão | Baixa | Média | ⬜ Pendente |

### Fase 4 - Polish & UX
| # | Feature | Prioridade | Complexidade | Status |
|---|---------|------------|--------------|--------|
| 4.1 | Home EAD | Média | Média | ⬜ Pendente |
| 4.2 | Busca de Cursos | Baixa | Média | ⬜ Pendente |
| 4.3 | Notificações EAD | Baixa | Média | ⬜ Pendente |
| 4.4 | Offline Support | Baixa | Alta | ⬜ Pendente |

---

## 4. Detalhamento Técnico

### 4.1 Domain Models

#### CursoModel (Simplificado para Mobile)
```dart
class CursoModel {
  final String id;
  final String titulo;
  final String descricaoCurta;
  final String? descricao;        // HTML
  final String? imagemCapa;
  final String? videoPreview;
  final StatusCurso status;
  final AutorCursoModel? autor;
  final int totalAulas;
  final int totalTopicos;
  final String? duracaoEstimada;
  final List<String> tags;
  final List<String> objetivos;
  
  // Campos calculados para o aluno
  bool isInscrito;
  double progressoPercentual;
}
```

#### InscricaoCursoModel (Reutilizar do Web)
```dart
// MANTER IDÊNTICO ao web para compatibilidade
class InscricaoCursoModel {
  final String id;
  final String cursoId;
  final String usuarioId;
  final StatusInscricao status;
  final ProgressoCursoModel progresso;
  final DateTime? dataConclusao;
  final bool certificadoGerado;
}
```

### 4.2 Repository Pattern

```dart
abstract class EadRepository {
  // Cursos
  Future<List<CursoModel>> getCursosDisponiveis();
  Future<CursoModel?> getCursoById(String id);
  Future<List<AulaModel>> getAulasByCurso(String cursoId);
  Future<List<TopicoModel>> getTopicosByAula(String cursoId, String aulaId);
  
  // Inscrições
  Future<List<InscricaoCursoModel>> getMeusInscritos(String usuarioId);
  Future<InscricaoCursoModel?> getInscricao(String cursoId, String usuarioId);
  Future<void> inscreverNoCurso(String cursoId);
  Future<void> cancelarInscricao(String inscricaoId);
  
  // Progresso
  Future<void> marcarTopicoCompleto(String inscricaoId, String topicoId);
  Future<void> marcarTopicoIncompleto(String inscricaoId, String topicoId);
  Future<void> atualizarUltimoAcesso(String inscricaoId, String topicoId);
  
  // Quiz
  Future<List<QuizQuestionModel>> getQuizByTopico(String topicoId);
  Future<void> salvarResultadoQuiz(String inscricaoId, String topicoId, double nota);
}
```

### 4.3 Fluxo de Navegação

```
┌─────────────┐
│  Home App   │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌──────────────────┐
│  EAD Home   │────▶│  Meus Cursos     │
└──────┬──────┘     └────────┬─────────┘
       │                     │
       ▼                     │
┌─────────────┐              │
│  Catálogo   │              │
└──────┬──────┘              │
       │                     │
       ▼                     ▼
┌─────────────────────────────────┐
│        Detalhes do Curso        │
│   (currículo, inscrever, etc)   │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│         Player Tópico           │
│  (vídeo, áudio, texto, quiz)    │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│    Certificado (ao concluir)    │
└─────────────────────────────────┘
```

---

## 5. Sincronização Web ↔ Mobile

### 5.1 Collections Firestore Compartilhadas

| Collection | Escrita Web | Escrita Mobile | Leitura Mobile |
|------------|-------------|----------------|----------------|
| `cursos` | ✅ CRUD | ❌ | ✅ |
| `cursos/{id}/aulas` | ✅ CRUD | ❌ | ✅ |
| `cursos/{id}/aulas/{id}/topicos` | ✅ CRUD | ❌ | ✅ |
| `inscricoes_cursos` | ✅ (admin) | ✅ (aluno) | ✅ |

### 5.2 Regras de Negócio

1. **Cursos** são gerenciados apenas pelo Web Admin
2. **Inscrições** podem ser criadas pelo mobile (aluno se inscreve)
3. **Progresso** é atualizado pelo mobile conforme aluno avança
4. **Status Inscrição** pode mudar automaticamente:
   - `ativo` → `concluido` quando 100% concluído
   - Admin pode alterar manualmente via web

---

## 6. Ordem de Implementação Sugerida

### Sprint 1 (Fundação)
1. ⬜ Criar estrutura de pastas EAD
2. ⬜ Implementar Domain Models
3. ⬜ Implementar EAD Repository + Service
4. ⬜ Configurar rotas no GoRouter

### Sprint 2 (Catálogo)
5. ⬜ Catálogo de Cursos (lista)
6. ⬜ Detalhes do Curso
7. ⬜ Funcionalidade de Inscrição

### Sprint 3 (Meus Cursos)
8. ⬜ Tela Meus Cursos
9. ⬜ Indicadores de Progresso
10. ⬜ Continuar de onde parou

### Sprint 4 (Player)
11. ⬜ Player de Vídeo (YouTube + URL direta)
12. ⬜ Player de Áudio (reutilizar existente)
13. ⬜ Visualização de Texto/HTML
14. ⬜ Mark as Complete

### Sprint 5 (Quiz & Polish)
15. ⬜ Tela de Quiz
16. ⬜ Home EAD
17. ⬜ Certificado
18. ⬜ Polimento e testes

---

## 7. Componentes Reutilizáveis do Projeto

### Do próprio MeditaBK Mobile
- `YouTubePlayerWidget` - já existe em `ui/core/widgets/`
- `AudioPlayerWidget` - já existe em `ui/core/widgets/`
- `HtmlDisplayWidget` - já existe em `ui/core/widgets/`
- Theme e estilos do app

### Do lib_sample (adaptar)
- `CourseTile` → `CursoCard`
- `MarkCompleteButton` → adaptar lógica
- `MyCourseTile` → `MeuCursoCard`
- `QuizScreen` → estrutura base

---

## 8. Considerações Técnicas

### 8.1 State Management
- Usar **Provider + ChangeNotifier** (padrão do projeto)
- ViewModels para cada página

### 8.2 Caching
- Cursos podem ser cacheados localmente (SharedPreferences ou Hive)
- Progresso deve ser sincronizado com Firestore

### 8.3 Offline Support (Fase futura)
- Permitir download de vídeos para assistir offline
- Sincronizar progresso quando voltar online

### 8.4 Performance
- Lazy loading de aulas e tópicos
- Paginação na lista de cursos se necessário
- Imagens com CachedNetworkImage

---

## 9. Próximos Passos Imediatos

1. **Aprovar este plano** - ajustar conforme necessário
2. **Criar Domain Models** - começar pela base
3. **Implementar Repository** - camada de dados
4. **Primeira tela** - Catálogo de Cursos

---

> **Nota:** Este plano pode ser ajustado conforme o desenvolvimento avança.
> Atualizar este documento conforme features são implementadas.
