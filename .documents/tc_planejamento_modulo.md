# MEDITA BK
## Traffic Control — Controle de Tráfego dos Pensamentos

**Documento de Planejamento do Módulo**
**Gestão de Alarmes para Meditação**

**Projeto:** MeditaBK | **Versão:** 1.0 | **Fevereiro 2026**
Arquitetura MVVM • Flutter • iOS & Android

---

## 1. Visão Geral do Módulo

### 1.1 Conceito
O módulo Traffic Control (TC) é um sistema de alarmes inteligentes que lembra o usuário de meditar em horários definidos por ele. Diferente de uma notificação convencional, o alarme acorda o app e reproduz diretamente uma música/áudio de meditação, proporcionando uma experiência imersiva e suave.

### 1.2 Nomenclatura
- **Nome público (UI):** "Controle de Tráfego dos Pensamentos" ou "Traffic Control"
- **Prefixo interno no código:** `tc_`

**Recomendação:** usar o prefixo `tc_` nos nomes de arquivos e classes para manter concisão e boa leitura. Exemplo: `TcAlarmEntity`, `tc_alarm_repository.dart`, `TcHomeViewModel`. O prefixo curto facilita buscas no projeto e mantém consistência sem prejudicar legibilidade.

### 1.3 Ponto de Entrada
O acesso ao módulo será através do item "Lembretes para Meditar" na página de Configurações do app. O código existente nesse item será preservado em um arquivo separado (legado) não referenciado por nenhuma rota.

### 1.4 Requisitos Funcionais Resumidos
- Listar, criar, editar, duplicar e deletar alarmes
- Cada alarme: horário, título, música (de collection pré-definida), duração
- Toggle on/off individual e global (todos os alarmes)
- Reproduzir áudio automaticamente no horário — foreground ou background
- Duração: encerrar no fim do áudio ou no tempo definido (o que ocorrer primeiro)
- Músicas baixadas em cache local — play sempre offline
- Configurações persistidas no device (funciona online e offline)
- Funcionar em iOS e Android
- Não gerar notificação visual — apenas reproduzir o áudio

---

## 2. Arquitetura MVVM — Estrutura de Pastas

Seguindo o padrão MVVM do `flutter_standards.md` e o estilo Compass:

```
lib/
  ui/
    traffic_control/
      tc_home_page/
        tc_home_page.dart                    # Lista de alarmes
        view_model/
          tc_home_view_model.dart
        widgets/
          tc_alarm_card.dart                  # Card de cada alarme
          tc_global_toggle.dart               # Toggle master on/off
          tc_empty_state.dart                 # Estado sem alarmes
      tc_alarm_form_page/
        tc_alarm_form_page.dart               # Criar/Editar alarme
        view_model/
          tc_alarm_form_view_model.dart
        widgets/
          tc_time_picker.dart
          tc_music_selector.dart              # Seletor de música
          tc_duration_picker.dart
      tc_music_picker_page/
        tc_music_picker_page.dart             # Escolher música da collection
        view_model/
          tc_music_picker_view_model.dart
        widgets/
          tc_music_tile.dart
          tc_music_preview_player.dart        # Preview com play/pause

  domain/
    models/
      traffic_control/
        tc_alarm_entity.dart                  # Entidade de domínio
        tc_music_entity.dart                  # Entidade de música

  data/
    repositories/
      tc_alarm_repository.dart                # Fonte de verdade alarmes
      tc_music_repository.dart                # Fonte de verdade músicas
    services/
      tc_alarm_scheduler_service.dart         # Integração com pacote alarm
      tc_audio_cache_service.dart             # Download e cache de áudios
      tc_local_storage_service.dart           # Persistência local (Hive)
      tc_music_api_service.dart               # API busca collection de músicas
    models/
      tc_alarm_model.dart                     # DTO JSON
      tc_music_model.dart                     # DTO JSON
```

### 2.1 Painel Administrativo (Web)
No projeto `medita-bk-web-admin`, criar o CRUD para a collection de músicas do Traffic Control:

```
lib/
  ui/
    traffic_control_music/
      tc_music_list_page/
        tc_music_list_page.dart
        view_model/
          tc_music_list_view_model.dart
      tc_music_form_page/
        tc_music_form_page.dart
        view_model/
          tc_music_form_view_model.dart
  data/
    repositories/
      tc_music_admin_repository.dart
    services/
      tc_music_admin_service.dart
```

---

## 3. Modelos de Dados

### 3.1 TcAlarmEntity (Domínio)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | String | UUID único do alarme |
| title | String | Título exibido ao usuário (ex: "Meditação Matinal") |
| hour | int | Hora do alarme (0–23) |
| minute | int | Minuto do alarme (0–59) |
| musicId | String | ID da música selecionada da collection |
| musicTitle | String | Nome da música (para exibição offline) |
| musicUrl | String | URL original do áudio no bucket |
| maxDurationSec | int | Duração máxima em segundos (0 = sem limite) |
| isEnabled | bool | Alarme ativo ou desativado |
| daysOfWeek | List&lt;int&gt; | Dias da semana ativos (1=seg, 7=dom). Vazio = diário |
| createdAt | DateTime | Data de criação |

### 3.2 TcMusicEntity (Domínio)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | String | ID único da música na collection |
| title | String | Nome exibido ao usuário |
| artist | String? | Artista/compositor (opcional) |
| audioUrl | String | URL do arquivo de áudio no bucket |
| thumbnailUrl | String? | URL da imagem de capa (opcional) |
| durationSec | int | Duração total do áudio em segundos |
| category | String? | Categoria (relaxamento, foco, etc.) |
| isActive | bool | Visível para usuários no app |

---

## 4. Stack Técnica — Pacotes Flutter

| Pacote | Função | Justificativa |
|--------|--------|---------------|
| alarm (^5.x) | Agendamento de alarmes | Plugin cross-platform (iOS+Android) que usa AlarmManager + Foreground Service no Android e AVAudioPlayer no iOS. Funciona com app terminado. |
| just_audio | Reprodução de áudio | Player robusto com suporte a arquivos locais, controle de duração, volume e loop. Já utilizado no app para meditações. |
| hive / hive_flutter | Persistência local | Banco NoSQL rápido, leve, funciona 100% offline. Ideal para salvar configurações de alarmes no device. |
| flutter_cache_manager | Cache de áudios | Gerencia download e cache de arquivos remotos. Garante que músicas estejam sempre disponíveis offline. |
| provider | State management | Padrão do projeto — ChangeNotifier + Provider. |
| go_router | Navegação | Padrão do projeto para rotas. |
| uuid | Geração de IDs | UUID para identificar alarmes de forma única. |
| dio | HTTP client | Padrão do projeto para chamadas API. |

### 4.1 Sobre o pacote alarm
O pacote [alarm](https://pub.dev/packages/alarm) é a escolha principal por ser o único plugin cross-platform que resolve o agendamento de alarmes com áudio tanto em iOS quanto Android sem necessidade de código nativo adicional.

**Características chave:**
- **Android:** Foreground Service + AlarmManager garante disparo mesmo com app terminado
- **iOS:** AVAudioPlayer silencioso mantém app ativo + Background App Refresh
- Suporte a áudio local (assets ou arquivos baixados)
- Stream de eventos para reagir quando alarme dispara
- Controle de volume, vibração e loop de áudio

**Nota:** No iOS, se o usuário reiniciar o device ou o sistema encerrar o app por pressão de memória, o alarme pode não disparar. Implementar notificação de aviso quando app é encerrado (`enableNotificationOnKill`).

---

## 5. Fluxos Principais

### 5.1 Fluxo de Dados (MVVM)

```
                ┌─────────────────────┐
                │   UI (View/Page)  │
                └─────────┬───────────┘
                        │ Consumer/watch()
                ┌─────────┴───────────┐
                │    ViewModel       │  ChangeNotifier
                └─────────┬───────────┘
                        │
                ┌─────────┴───────────┐
                │    Repository      │  Fonte de verdade
                └───┬─────────┬───────┘
                    │             │
          ┌───────┴───┐  ┌───┴─────────┐
          │ Local Svc │  │ Remote Svc  │
          │  (Hive)   │  │   (Dio)     │
          └───────────┘  └─────────────┘
```

### 5.2 Criar Novo Alarme
1. Usuário toca botão "+" na tela TC Home
2. Navega para `TcAlarmFormPage` (modo criação)
3. Seleciona horário (TimePicker nativo)
4. Informa título do alarme
5. Toca em "Selecionar Música" → abre `TcMusicPickerPage`
6. Lista de músicas carregada da API (collection pré-definida)
7. Pode ouvir preview de cada música antes de selecionar
8. Seleciona música e retorna ao formulário
9. Define duração máxima (ou deixa "até o fim do áudio")
10. Salva → ViewModel chama Repository → persiste no Hive + agenda no alarm
11. Cache Service baixa o áudio para armazenamento local

### 5.3 Disparo do Alarme
1. Pacote `alarm` dispara no horário agendado (foreground ou background)
2. App é acordado via `Alarm.ringStream`
3. AudioCacheService verifica se arquivo está em cache (senão re-baixa)
4. `just_audio` reproduz o áudio local
5. Timer monitora: encerra no `maxDurationSec` OU quando áudio termina (o que vier primeiro)
6. Se `loopAudio=false` no pacote alarm, áudio para naturalmente no fim
7. Reagendar próximo disparo (próximo dia ou próximo dia da semana configurado)

### 5.4 Cache de Áudios
Todas as músicas vinculadas a alarmes ativos devem estar disponíveis offline. O fluxo é:
- Ao selecionar música no alarme, `AudioCacheService.ensureCached(url)` é chamado
- `flutter_cache_manager` baixa o arquivo e armazena localmente
- No disparo do alarme, sempre usar o path local do cache
- Ao iniciar o app, verificar integridade: re-baixar se arquivo ausente
- Ao deletar alarme, verificar se música é usada por outro alarme antes de limpar cache

---

## 6. Especificação de Telas

### 6.1 TC Home Page — Lista de Alarmes

| Elemento | Especificação |
|----------|---------------|
| AppBar | Título: "Traffic Control" com ícone de avião/torre de controle. Seguir tema do app. |
| Toggle Global | Switch master no topo: "Ativar todos os lembretes". Liga/desliga todos de uma vez. |
| Lista de Alarmes | Cards em ListView com: horário (grande), título, nome da música, switch on/off individual. |
| Ações por Card | Swipe ou long press: Editar, Duplicar, Deletar (com confirmação). |
| Estado Vazio | Ilustração + texto motivacional + botão CTA para criar primeiro alarme. |
| FAB | Botão flutuante "+" para criar novo alarme. Cor accent do tema. |

### 6.2 TC Alarm Form Page — Criar/Editar

| Elemento | Especificação |
|----------|---------------|
| Horário | TimePicker centralizado grande estilo relógio. Formato 24h ou AM/PM conforme device. |
| Título | TextField com placeholder "Ex: Meditação Matinal". Máx 50 caracteres. |
| Música | Tile clicável mostrando música selecionada com mini-player. Toque abre MusicPickerPage. |
| Duração | Slider ou picker: "Até o fim do áudio" (default) ou valor específico (1–60 min). |
| Dias da Semana | Chips selecionáveis para cada dia. Padrão: todos (diário). |
| Botão Salvar | Botão primário "Salvar Alarme". Validação antes de salvar. |

### 6.3 TC Music Picker Page

| Elemento | Especificação |
|----------|---------------|
| Busca | SearchBar no topo para filtrar por nome. |
| Categorias | Chips horizontais para filtrar por categoria (Relaxamento, Foco, Natureza...). |
| Lista | Tiles com: thumbnail, título, artista, duração, botão play para preview. |
| Preview | Mini player fixo no bottom ao tocar play. Pause/stop. Não interfere com seleção. |
| Seleção | Tap no tile seleciona (checkmark). Botão confirmar no bottom ou AppBar. |

---

## 7. Painel Administrativo — Collection de Músicas

No projeto `medita-bk-web-admin`, deve ser criado um CRUD completo para gerenciar a collection de músicas disponíveis para o Traffic Control.

### 7.1 Funcionalidades Admin
- Listagem paginada de músicas com busca e filtro por categoria
- Criar nova música: upload de áudio (MP3/AAC), thumbnail, título, artista, categoria
- Editar música existente (metadados e substituir arquivo)
- Ativar/Desativar música (soft delete — não remove, apenas oculta do app)
- Deletar música (com aviso se vinculada a alarmes de usuários)
- Preview de áudio na própria listagem admin

### 7.2 Bucket de Armazenamento
Os áudios devem ser armazenados em um bucket/collection dedicado, seguindo o padrão já usado pelas meditações do app. Sugestão de path: `traffic_control/musics/` no mesmo storage já utilizado.

---

## 8. Persistência e Offline

### 8.1 Armazenamento Local (Hive)

Os alarmes configurados pelo usuário serão persistidos localmente no device usando Hive, garantindo funcionamento completo offline.

| Aspecto | Detalhe |
|---------|---------|
| Box name | `tc_alarms` |
| Formato | JSON serializado via TypeAdapter do Hive |
| Chave | `alarmId` (UUID string) |
| Migração | Versionamento embutido para futuras alterações de schema |
| Backup | Não sincroniza com servidor (dados ficam apenas no device) |

### 8.2 Cache de Áudios
- Usar `flutter_cache_manager` com chave customizada por `musicId`
- Download iniciado ao vincular música ao alarme
- Verificação de integridade no boot do app (re-download se necessário)
- Play sempre do arquivo local — nunca streaming
- Máximo de espaço em cache configurável (sugestão: 200 MB)

---

## 9. Configurações de Plataforma

### 9.1 Android
Permissões necessárias no `AndroidManifest.xml`:
- `RECEIVE_BOOT_COMPLETED` — re-agendar alarmes após reboot
- `WAKE_LOCK` — manter device ativo para reproduzir
- `SCHEDULE_EXACT_ALARM` — alarmes exatos (Android 12+)
- `USE_EXACT_ALARM` — alternativa para Android 14+
- `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` (solicitar ao usuário)

Registrar o AlarmService e BroadcastReceiver conforme documentação do pacote `alarm`.

### 9.2 iOS
Configurações no Xcode/Info.plist:
- **Background Modes:** Audio, AirPlay and Picture in Picture
- **Background Modes:** Background Fetch
- **NSAppTransportSecurity:** AllowsArbitraryLoads (para cache de áudio)

**Importante:** Orientar usuários iOS que encerrar o app manualmente (force-quit) pode impedir o alarme de disparar. Exibir um aviso sutil na primeira configuração.

---

## 10. Dependency Injection

Seguindo o padrão do projeto com Provider, a ordem de registro deve ser:

```dart
// 1. Services (infraestrutura)
Provider<TcLocalStorageService>(create: (_) => TcLocalStorageService()),
Provider<TcMusicApiService>(create: (_) => TcMusicApiService(dio)),
Provider<TcAudioCacheService>(create: (_) => TcAudioCacheService()),
Provider<TcAlarmSchedulerService>(create: (_) => TcAlarmSchedulerService()),

// 2. Repositories
ChangeNotifierProvider<TcAlarmRepository>(
  create: (ctx) => TcAlarmRepository(
    localStorage: ctx.read<TcLocalStorageService>(),
    scheduler: ctx.read<TcAlarmSchedulerService>(),
    audioCache: ctx.read<TcAudioCacheService>(),
  ),
),
ChangeNotifierProvider<TcMusicRepository>(
  create: (ctx) => TcMusicRepository(
    api: ctx.read<TcMusicApiService>(),
  ),
),

// 3. ViewModels
ChangeNotifierProxyProvider<TcAlarmRepository, TcHomeViewModel>(...),
ChangeNotifierProxyProvider<TcAlarmRepository, TcAlarmFormViewModel>(...),
ChangeNotifierProxyProvider<TcMusicRepository, TcMusicPickerViewModel>(...),
```

---

## 11. Rotas (GoRouter)

| Path | Page | Paramêtros |
|------|------|------------|
| `/settings/traffic-control` | TcHomePage | — |
| `/settings/traffic-control/new` | TcAlarmFormPage | mode: create |
| `/settings/traffic-control/edit/:id` | TcAlarmFormPage | alarmId |
| `/settings/traffic-control/music-picker` | TcMusicPickerPage | — |

---

## 12. Plano de Fases de Implementação

| Fase | Nome | Escopo | Estimativa |
|------|------|--------|------------|
| 1 | Fundação & Modelos | Modelos de domínio, DTOs, Hive setup, entidades, services base | 2–3 dias |
| 2 | Admin — CRUD Músicas | Painel admin: listagem, criação, edição, upload de áudios para o bucket | 2–3 dias |
| 3 | App — Tela Home TC | TcHomePage com lista de alarmes, toggle global, empty state, card widget | 2–3 dias |
| 4 | App — Form de Alarme | TcAlarmFormPage: criação, edição, time picker, music selector, duration | 3–4 dias |
| 5 | App — Music Picker | TcMusicPickerPage: listagem, categorias, busca, preview com mini player | 2–3 dias |
| 6 | Agendamento & Alarme | Integração pacote alarm, foreground service, disparo, reagendamento | 3–4 dias |
| 7 | Cache & Áudio | Download, cache local, verificação de integridade, play offline | 2–3 dias |
| 8 | Testes & Polish | Testes unitários, integração, ajustes de UX, edge cases, QA | 3–4 dias |

**Estimativa total:** 19 a 27 dias de desenvolvimento

---

## 13. Estratégia de Testes

| Camada | O que testar | Abordagem |
|--------|--------------|-----------|
| Domain | Entidades, serialização | Unit tests com modelos fake |
| Data | Repositories, cache logic | Unit tests com mocks de services |
| ViewModel | Lógica de estado, commands | Unit tests com mocks de repositories |
| UI | Widgets, interações | Widget tests com Provider mock |
| Integração | Fluxo completo criar alarme | Integration tests ponta a ponta |

---

## 14. Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| iOS kill do app impede alarme | Alto | Notificação de aviso ao usuário + `enableNotificationOnKill` |
| Fabricantes Android (bateria) | Médio | Tela educativa pedindo desativar otimização de bateria ([dontkillmyapp.com](https://dontkillmyapp.com)) |
| Cache corrompido/ausente | Médio | Verificação de integridade no boot + re-download automático |
| Alarmes não reagendam após reboot | Alto | `RECEIVE_BOOT_COMPLETED` + re-schedule no init do app |
| Conflito FCM + pacote alarm | Baixo | Versão 5.x do pacote alarm já resolve colisão com FCM |
| Espaço em disco (muitas músicas) | Baixo | Limite de cache + limpeza de áudios não utilizados |

---

## 15. Checklist de Aceitação

- [ ] Usuário consegue criar alarme com horário, título e música
- [ ] Usuário consegue listar, editar, duplicar e deletar alarmes
- [ ] Toggle individual liga/desliga alarme
- [ ] Toggle global liga/desliga todos os alarmes
- [ ] Alarme dispara no horário correto (foreground e background)
- [ ] Áudio reproduz automaticamente ao disparar
- [ ] Áudio encerra no tempo definido ou fim da faixa (o que ocorrer primeiro)
- [ ] Músicas são baixadas para cache local
- [ ] Play sempre local (offline) — nunca streaming
- [ ] Configurações persistem após fechar/reabrir app
- [ ] Funciona em iOS e Android
- [ ] Admin web permite CRUD de músicas na collection
- [ ] Interface segue padrão visual e paleta do MeditaBK
- [ ] Código segue arquitetura MVVM do `flutter_standards.md`
- [ ] Código legado de 'lembretes' preservado em arquivo separado

---

**Documento gerado para avaliação — MeditaBK Traffic Control Module**
