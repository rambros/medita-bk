# Guia de Implementação - Cache de Imagens

## 📋 Resumo da Implementação

Esta implementação resolve o erro `HttpException: Connection closed before full header was received` que ocorria ao carregar imagens do Firebase Storage.

### ✅ O que foi feito:

1. **Atualizado `ImageUtils`** para usar `CachedNetworkImage`
2. **Migrados widgets principais** para usar cache de imagens
3. **Adicionado método helper** simplificado (`ImageUtils.cachedImage()`)

---

## 🎯 Benefícios

### Antes (Image.network):
- ❌ Sem retry automático
- ❌ Recarrega imagem toda vez
- ❌ Gera erros fatais no Crashlytics
- ❌ Desperdiça dados móveis
- ❌ UX ruim em redes lentas

### Depois (CachedNetworkImage):
- ✅ Retry automático em falhas
- ✅ Cache em disco (persiste entre sessões)
- ✅ Cache em memória (carregamento instantâneo)
- ✅ Reduz erros no Crashlytics
- ✅ Economiza dados móveis
- ✅ Loading indicators e placeholders

---

## 🚀 Como Usar

### Opção 1: Método Helper Simplificado (Recomendado)

```dart
import 'package:medita_bk/core/utils/image_utils.dart';

// Uso básico
ImageUtils.cachedImage(
  url: meditation.imageUrl,
  width: 200,
  height: 200,
)

// Com bordas arredondadas
ImageUtils.cachedImage(
  url: meditation.imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(16),
)

// Com ícone customizado de erro
ImageUtils.cachedImage(
  url: user.profilePicture,
  width: 80,
  height: 80,
  errorIcon: Icons.person,
  placeholderColor: Colors.grey[200],
)
```

### Opção 2: ImageUtils com Tratamento de Erro

```dart
import 'package:medita_bk/core/utils/image_utils.dart';

ImageUtils.buildNetworkImage(
  url: meditation.imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
  onError: (isNetworkError, message) {
    if (isNetworkError) {
      // Erro de rede - pode mostrar snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sem conexão: $message')),
      );
    }
  },
)
```

### Opção 3: CachedNetworkImage Direto

```dart
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    color: Colors.grey[200],
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) => Container(
    color: Colors.grey[300],
    child: Icon(Icons.error, size: 32),
  ),
  // Configurações de cache
  maxHeightDiskCache: 400,
  maxWidthDiskCache: 400,
  memCacheHeight: 400,
  memCacheWidth: 400,
)
```

---

## ⚙️ Configurações de Cache

Use estas configurações conforme o tamanho da imagem:

| Tipo de Imagem | Tamanho | disk/mem cache |
|---------------|---------|----------------|
| Thumbnail pequeno | 50-100px | 200 |
| Card médio | 100-300px | 400 |
| Imagem grande | 300-600px | 1000 |
| Avatar circular | 60-120px | 500 |

```dart
// Exemplo para card médio
CachedNetworkImage(
  imageUrl: url,
  maxHeightDiskCache: 400,  // 2x o tamanho visual
  maxWidthDiskCache: 400,
  memCacheHeight: 400,
  memCacheWidth: 400,
)
```

---

## 📂 Arquivos Já Migrados

✅ **Core Utils:**
- `lib/core/utils/image_utils.dart`

✅ **Widgets:**
- `lib/ui/meditation/widgets/meditation_card_widget.dart`
- `lib/ui/desafio/widgets/card_dia_meditacao_widget.dart`
- `lib/ui/ead/catalogo_cursos_page/widgets/curso_card.dart` (já usava)
- `lib/ui/config/edit_profile_page/edit_profile_page.dart` (já usava)

---

## 📝 Arquivos Pendentes

❗ Ainda precisam ser migrados (8 arquivos):

```bash
lib/ui/traffic_control/tc_music_picker_page/widgets/tc_music_tile.dart
lib/ui/desafio/widgets/carousel_get_ebooks_widget.dart
lib/ui/desafio/widgets/carousel_get_brasao_widget.dart
lib/ui/desafio/widgets/carousel_get_mandalas_widget.dart
lib/ui/desafio/widgets/get_mandala_widget.dart
lib/ui/desafio/widgets/desafio_active_view_widget.dart
lib/ui/ead/curso_detalhes_page/curso_detalhes_page.dart
lib/ui/playlist/select_images_playlist/select_images_playlist.dart
```

### Como migrar:

1. **Adicionar import:**
```dart
import 'package:cached_network_image/cached_network_image.dart';
```

2. **Substituir Image.network:**
```dart
// ANTES
Image.network(
  imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  errorBuilder: (_, __, ___) => Icon(Icons.error),
)

// DEPOIS
CachedNetworkImage(
  imageUrl: imageUrl,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  maxHeightDiskCache: 400,
  maxWidthDiskCache: 400,
)
```

---

## 🔍 Como Encontrar Usos de Image.network

Execute no terminal:

```bash
# Encontrar arquivos que ainda usam Image.network
grep -r "Image\.network" lib --include="*.dart"

# Encontrar arquivos que usam NetworkImage
grep -r "NetworkImage" lib --include="*.dart"
```

---

## 🧪 Testando

1. **Teste com rede lenta:**
   - Use o throttling do Chrome DevTools ou Android Emulator
   - Verifique se o placeholder aparece

2. **Teste sem internet:**
   - Desabilite wifi/dados
   - Verifique se o errorWidget aparece
   - Reative conexão - imagem deve carregar automaticamente

3. **Teste cache:**
   - Carregue imagens
   - Feche e reabra app
   - Imagens devem aparecer instantaneamente (do cache)

---

## 📚 Documentação

- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

---

## 🐛 Troubleshooting

### Imagens não carregam após atualização

Limpe o cache do app:

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Limpar cache de imagens
await DefaultCacheManager().emptyCache();
```

### Erro de espaço em disco

O `cached_network_image` gerencia automaticamente o cache, mas você pode configurar:

```dart
CachedNetworkImage(
  imageUrl: url,
  // Limita cache de disco por imagem
  maxHeightDiskCache: 1000,
  maxWidthDiskCache: 1000,
)
```

---

## 📞 Contato

Para dúvidas ou problemas, contate a equipe de desenvolvimento.

Última atualização: 2026-03-27
