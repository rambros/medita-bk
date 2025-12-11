# Documentação do Projeto Medita Backend

Este diretório contém toda a documentação técnica do projeto, organizada por funcionalidade.

## Estrutura

### [notificacoes/](notificacoes/)
Documentação completa do sistema de notificações

- **[NOTIFICACOES_UNIFICADAS.md](notificacoes/NOTIFICACOES_UNIFICADAS.md)** - Visão geral do sistema unificado de notificações
- **[sistema_notificacoes_user_states.md](notificacoes/sistema_notificacoes_user_states.md)** - Sistema de estados por usuário (lido/oculto)
- **[NOTIFICACOES_BADGE_SETUP.md](notificacoes/NOTIFICACOES_BADGE_SETUP.md)** - Configuração de badges e contadores
- **[QUAL_COLLECTION_USAR.md](notificacoes/QUAL_COLLECTION_USAR.md)** - Guia para escolher a collection correta
- **[CRIAR_NOTIFICACAO_TESTE.md](notificacoes/CRIAR_NOTIFICACAO_TESTE.md)** - Como criar notificações de teste
- **[NOTIFICACOES_TROUBLESHOOTING.md](notificacoes/NOTIFICACOES_TROUBLESHOOTING.md)** - Solução de problemas comuns
- **[firestore_rules_notificacoes.txt](notificacoes/firestore_rules_notificacoes.txt)** - Regras de segurança do Firestore

### [refatoracao/](refatoracao/)
Planos e documentação de refatorações e melhorias do código

- **[refatoracao_imports.md](refatoracao/refatoracao_imports.md)** - Plano de migração de imports relativos para absolutos

## Navegação Rápida

### Por Contexto de Uso

**Desenvolvedor trabalhando com notificações:**
1. Comece com [NOTIFICACOES_UNIFICADAS.md](notificacoes/NOTIFICACOES_UNIFICADAS.md)
2. Veja qual collection usar: [QUAL_COLLECTION_USAR.md](notificacoes/QUAL_COLLECTION_USAR.md)
3. Configure badges: [NOTIFICACOES_BADGE_SETUP.md](notificacoes/NOTIFICACOES_BADGE_SETUP.md)

**Testando notificações:**
1. Siga o guia: [CRIAR_NOTIFICACAO_TESTE.md](notificacoes/CRIAR_NOTIFICACAO_TESTE.md)
2. Se tiver problemas: [NOTIFICACOES_TROUBLESHOOTING.md](notificacoes/NOTIFICACOES_TROUBLESHOOTING.md)

**Configurando Firebase:**
1. Aplique as regras: [firestore_rules_notificacoes.txt](notificacoes/firestore_rules_notificacoes.txt)

**Planejando refatorações:**
1. Veja os planos existentes em [refatoracao/](refatoracao/)

## Contribuindo

Ao adicionar nova documentação:
- Coloque-a na pasta apropriada por funcionalidade
- Atualize este README.md com links para o novo documento
- Use nomes descritivos em CAPS para guias principais
- Use snake_case para documentação técnica detalhada
