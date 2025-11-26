**Para criar e plugar uma nova página no projeto (mantendo o padrão atual):**

Criar a tela: adicione um novo diretório em lib/ui/<feature>/<page_name>/ e crie <page_name>.dart com class <PascalCase>Page extends StatefulWidget (ou Stateless), static routeName/routePath e o State correspondente. Se usar MVVM, crie view_model/<page_name>_view_model.dart.
Exportar: inclua um export em lib/index.dart apontando para a nova página (export '/ui/<feature>/<page_name>/<page_name>.dart' show <PascalCase>Page;) para manter os imports curtos.
Rotas (GoRouter): em lib/routing/nav.dart, adicione um FFRoute com name: <PascalCase>Page.routeName, path: <PascalCase>Page.routePath, e builder: (context, params) => const <PascalCase>Page() (ou passando params). Se ela precisa estar sob a árvore de navegação principal, coloque dentro da rota _initialize como as demais.
Navegação a partir de outras telas: onde for chamar, use context.pushNamed(<PascalCase>Page.routeName, ...) (ou goNamed se substituir a tela).
Injeção de dependências/VM: se a página tiver ViewModel, registre o provider no ponto de entrada adequado (geralmente dentro do widget via ChangeNotifierProvider no builder da rota) para manter o escopo da VM só naquela tela.
Static assets/strings: se precisar de assets, registre-os no pubspec.yaml. Strings/dados compartilhados vão em repositórios/use cases, não na página.
Testes/fluxo: opcionalmente, adicione um teste de widget simples que verifica renderização ou navegação, e rode flutter analyze para garantir que a rota e o export não quebraram o build.

**Exemplo**

Exemplo concreto para ui/cursos/lista_curso_page:

1. Criar o arquivo lib/ui/cursos/lista_curso_page/lista_curso_page.dart:
import 'package:flutter/material.dart';
import '/index.dart'; // se precisar navegar para outras páginas
// import 'view_model/lista_curso_view_model.dart'; // se usar VM

class ListaCursoPage extends StatefulWidget {
  const ListaCursoPage({super.key});

  static String routeName = 'listaCursoPage';
  static String routePath = 'listaCursoPage';

  @override
  State<ListaCursoPage> createState() => _ListaCursoPageState();
}

class _ListaCursoPageState extends State<ListaCursoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cursos')),
      body: const Center(child: Text('Lista de cursos')),
    );
  }
}
2. Exportar em lib/index.dart:
export '/ui/cursos/lista_curso_page/lista_curso_page.dart' show ListaCursoPage;

3. Registrar rota em lib/routing/nav.dart (dentro do array routes principal, junto das demais):
FFRoute(
  name: ListaCursoPage.routeName,
  path: ListaCursoPage.routePath,
  builder: (context, params) => const ListaCursoPage(),
),


4. Navegar a partir de outra tela:
context.pushNamed(ListaCursoPage.routeName);


5. Se usar ViewModel própria, crie lib/ui/cursos/lista_curso_page/view_model/lista_curso_view_model.dart e forneça no builder da rota:
builder: (context, params) => ChangeNotifierProvider(
  create: (_) => ListaCursoViewModel()..init(),
  child: const ListaCursoPage(),
),

6. Depois disso, rode flutter analyze e, se quiser, um teste de widget simples para garantir que a rota renderiza.