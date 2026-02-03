# Constantes do Módulo Desafio 21 Dias

## 📋 Visão Geral

O arquivo `desafio_strings.dart` centraliza todas as strings usadas no módulo
Desafio 21 Dias, facilitando manutenção, consistência e possível
internacionalização futura.

## 📁 Localização

```
lib/ui/desafio/constants/desafio_strings.dart
```

## 🎯 Benefícios

1. **Manutenção Centralizada**: Todas as strings em um único local
2. **Consistência**: Garante que a mesma mensagem seja usada em todos os lugares
3. **Facilita Tradução**: Preparado para i18n futura
4. **Type-Safe**: Erros de digitação são detectados em tempo de compilação
5. **Documentação**: Strings organizadas por categoria

## 📚 Categorias de Strings

### Título do Desafio

```dart
DesafioStrings.desafioTitle // "Desafio 21 dias"
```

### Mensagens de Status

```dart
DesafioStrings.waitNextDay           // "Precisa aguardar o próximo dia..."
DesafioStrings.completePreviousDay   // "Você precisa completar o dia anterior..."
DesafioStrings.waitUntilDate(date)   // "Aguarde até {date} para iniciar..."
```

### Mensagens de Conclusão

```dart
DesafioStrings.congratulations       // "Parabéns!"
DesafioStrings.challengeCompleted    // "Você completou o Desafio 21 dias!"
```

### Botões e Ações

```dart
DesafioStrings.startChallenge        // "Iniciar Desafio"
DesafioStrings.continueChallenge     // "Continuar"
DesafioStrings.resetChallenge        // "Reiniciar Desafio"
DesafioStrings.viewRewards           // "Ver Conquistas"
```

### Funções Dinâmicas

```dart
DesafioStrings.dayNumber(5)          // "Dia 5"
DesafioStrings.stageNumber(2)        // "Etapa 2"
DesafioStrings.daysCompleted(10)     // "10 dias completados"
```

## 💡 Como Usar

### 1. Importar o arquivo

```dart
import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';
```

### 2. Usar as constantes

```dart
// Ao invés de:
Text('Desafio 21 dias')

// Use:
Text(DesafioStrings.desafioTitle)
```

### 3. Funções com parâmetros

```dart
// Ao invés de:
Text('Aguarde até $formattedDate para iniciar o desafio.')

// Use:
Text(DesafioStrings.waitUntilDate(formattedDate))
```

## ✅ Arquivos Já Refatorados

- ✅ `status_meditacao_widget.dart` - Mensagens de status e bloqueios
- ✅ `desafio_play_page.dart` - Título da página

## 📝 Próximos Passos

Para continuar a refatoração:

1. Identificar strings hardcoded em outros arquivos
2. Adicionar novas constantes conforme necessário
3. Substituir strings pelos valores das constantes
4. Testar para garantir que tudo funciona corretamente

## 🔍 Encontrando Strings para Refatorar

```bash
# Buscar strings hardcoded no módulo desafio
grep -r "'[A-Z]" lib/ui/desafio/ --include="*.dart"
```

## 🌐 Preparação para Internacionalização

Este arquivo está preparado para futura integração com sistemas de i18n como:

- Flutter Intl
- Easy Localization
- GetX Translations

Quando implementar i18n, basta substituir as constantes por chamadas ao sistema
de tradução escolhido.

## 📖 Exemplo Completo

```dart
import 'package:flutter/material.dart';
import 'package:medita_bk/ui/desafio/constants/desafio_strings.dart';

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título
        Text(DesafioStrings.desafioTitle),
        
        // Dia dinâmico
        Text(DesafioStrings.dayNumber(5)),
        
        // Mensagem com parâmetro
        Text(DesafioStrings.waitUntilDate('01/02/2026')),
        
        // Botão
        ElevatedButton(
          onPressed: () {},
          child: Text(DesafioStrings.continueChallenge),
        ),
      ],
    );
  }
}
```

## 🤝 Contribuindo

Ao adicionar novas strings:

1. Adicione em `desafio_strings.dart` na categoria apropriada
2. Use nomes descritivos em camelCase
3. Adicione comentário se necessário
4. Atualize este README se criar nova categoria
