# Plano de Testes — Lembretes para Meditar

## Configuração dos testes

Crie **2 alarmes por cenário**, com intervalo de 2 minutos entre eles.
Registre o resultado imediatamente após cada disparo.

---

## Rodada A — `androidFullScreenIntent: false`

| # | Horário sugerido | Cenário | Estado do app | O que observar |
|---|---|---|---|---|
| A1 | T+5min | Tela bloqueada | App fechado (tela apagada) | Áudio tocou? Apareceu ícone? Apareceu popup? |
| A2 | T+7min | Tela bloqueada | App fechado (tela apagada) | Igual A1 (confirmar consistência) |
| A3 | T+10min | Background | App aberto, tela em outra tela do celular | Áudio tocou? Notificação apareceu? |
| A4 | T+12min | Background | App aberto, tela em outra tela do celular | Igual A3 |
| A5 | T+15min | Foreground (outra tela) | App aberto, usuário em outra página do app | Áudio tocou? Notificação? |
| A6 | T+17min | Foreground (TcHomePage) | App aberto na tela "Lembretes para Meditar" | Botão vermelho apareceu? Áudio tocou? |
| A7 | T+24h | Reagendamento | App fechado no dia seguinte | Alarme tocou no mesmo horário do dia seguinte? |

### Resultados Rodada A

**A1** — Tela bloqueada (1ª vez)
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**A2** — Tela bloqueada (2ª vez)
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**A3** — Background (1ª vez)
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**A4** — Background (2ª vez)
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**A5** — Foreground outra tela
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**A6** — Foreground TcHomePage
- Áudio tocou? ___
- Botão vermelho apareceu? ___
- Observações: ___

**A7** — Reagendamento (dia seguinte)
- Alarme tocou? ___
- Horário correto? ___
- Observações: ___

---

## Rodada B — `androidFullScreenIntent: true`

> Alterar em `lib/data/services/tc_alarm_scheduler_service.dart`:
> ```dart
> androidFullScreenIntent: true,
> ```
> Gerar novo build e repetir os mesmos cenários.

| # | Horário sugerido | Cenário | Estado do app | O que observar |
|---|---|---|---|---|
| B1 | T+5min | Tela bloqueada | App fechado (tela apagada) | Abriu tela por cima da tela bloqueada? Áudio tocou? |
| B2 | T+7min | Tela bloqueada | App fechado (tela apagada) | Igual B1 |
| B3 | T+10min | Background | App aberto, outra tela do celular | Áudio tocou? Abriu tela por cima? |
| B4 | T+12min | Background | App aberto, outra tela do celular | Igual B3 |
| B5 | T+15min | Foreground (outra tela) | App aberto, outra página | Áudio tocou? Notificação? |
| B6 | T+17min | Foreground (TcHomePage) | App aberto na tela "Lembretes" | Botão vermelho apareceu? Áudio tocou? |
| B7 | T+24h | Reagendamento | App fechado no dia seguinte | Alarme tocou no mesmo horário? |

### Resultados Rodada B

**B1** — Tela bloqueada (1ª vez)
- Áudio tocou? ___
- Tela abriu sobre lock screen? ___
- Notificação apareceu? ___
- Observações: ___

**B2** — Tela bloqueada (2ª vez)
- Áudio tocou? ___
- Tela abriu sobre lock screen? ___
- Notificação apareceu? ___
- Observações: ___

**B3** — Background (1ª vez)
- Áudio tocou? ___
- Tela abriu sobre lock screen? ___
- Notificação apareceu? ___
- Observações: ___

**B4** — Background (2ª vez)
- Áudio tocou? ___
- Tela abriu sobre lock screen? ___
- Notificação apareceu? ___
- Observações: ___

**B5** — Foreground outra tela
- Áudio tocou? ___
- Notificação apareceu? ___
- Observações: ___

**B6** — Foreground TcHomePage
- Áudio tocou? ___
- Botão vermelho apareceu? ___
- Observações: ___

**B7** — Reagendamento (dia seguinte)
- Alarme tocou? ___
- Horário correto? ___
- Observações: ___

---

## Ficha de registro — referência rápida

| Campo | Opções |
|---|---|
| Áudio tocou? | Sim / Não / Com atraso (quantos segundos?) |
| Notificação apareceu? | Sim popup grande / Sim ícone pequeno / Não |
| Tela abriu sobre lock screen? | Sim / Não (só relevante para B1/B2) |
| Botão "Parar" funcionou? | Sim / Não / Não apareceu |
| Reagendou corretamente? | Sim / Não / Não testado |
| Observações | Campo livre |

---

## Conclusão

**Rodada A (false):**
- Pontos positivos: ___
- Pontos negativos: ___

**Rodada B (true):**
- Pontos positivos: ___
- Pontos negativos: ___

**Decisão final:** Manter `androidFullScreenIntent: ___`
**Motivo:** ___
