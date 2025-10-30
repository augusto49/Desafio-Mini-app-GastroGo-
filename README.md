# 🍽️ GastroGo

**GastroGo** é um mini aplicativo Flutter que lista restaurantes e seus pratos, permite favoritar, filtrar, ordenar e visualizar detalhes — com estado gerenciado de forma clara, boas práticas de arquitetura e testes automatizados.  
O projeto foi desenvolvido como desafio técnico, priorizando legibilidade, desacoplamento e uma experiência fluida.

---

## 🚀 Instruções de Build & Execução

### 🧰 Pré-requisitos

- Flutter **3.29.3** ou superior
- Dart SDK compatível
- Android Studio ou VS Code com as extensões do Flutter

### ▶️ Rodar o projeto localmente

```bash
git clone https://github.com/augusto49/Desafio-Mini-app-GastroGo-.git
cd gastrogo
flutter pub get
flutter run
```

### ▶️ Verificar ao testar as funcionalidades

Quando for acessar alguma funcionalidade do aplicativo, recarregue ou entre na mesma pagina pelo menos 2 vezes pois esta com ERROR SIMULADO para simular queda da API.

### 🧩 Decisões de Arquitetura

O projeto segue uma arquitetura em camadas, com separação clara de responsabilidades:

- data/ → modelos, fontes de dados (JSON local) e repositórios.

- presentation/ → telas, widgets e provedores de estado.

- providers/ → gerenciamento de estado com Riverpod, garantindo imutabilidade e reatividade previsível.

Foi adotado o Repository Pattern, mesmo usando uma fonte local (LocalJsonSource), permitindo fácil substituição futura por uma API real.
O estado é gerenciado com Flutter Riverpod, por sua simplicidade, segurança em tempo de compilação e suporte a estados assíncronos (AsyncNotifier).
Favoritos são persistidos com SharedPreferences, garantindo continuidade entre execuções.
Para imagens, foi utilizado cached_network_image com placeholders e cache local.

### 🧪 Como Rodar Testes e Lint

- flutter test

Incluem:

Testes unitários de repositório e fonte de dados.

Testes de widget para lista e detalhes de restaurante.

### 🧹 Lint / Análise estática

flutter analyze
dart run very_good_analysis:analyze

O projeto segue as regras da Very Good Analysis, garantindo consistência e boas práticas de código.

### 🧱 Estrutura de Pastas

lib/
├── core/
├── data/
│ ├── models/
│ │ ├── dish_model.dart
│ │ ├── dish_model.g.dart
│ │ ├── restaurant_model.dart
│ │ └── restaurant_model.g.dart
│ ├── repositories/
│ │ └── food_repository.dart
│ └── sources/
│ ├── fake_remote_source.dart
│ └── local_json_source.dart
├── domain/
│ ├── entities/
│ └── usecases/
├── presentation/
│ ├── pages/
│ │ ├── favorites_page.dart
│ │ ├── home_page.dart
│ │ ├── restaurant_detail_page.dart
│ │ └── restaurants_page.dart
│ ├── providers/
│ │ ├── paginated_restaurants_provider.dart
│ │ ├── providers.dart
│ │ └── theme_provider.dart
│ └── widgets/
│ ├── dish_tile.dart
│ └── restaurant_card.dart
└── main.dart

### ⚙️ Integração Contínua (CI)

O projeto inclui um workflow GitHub Actions localizado em:

.github/workflows/ci.yml

Ele executa automaticamente a cada commit/pull request:

- flutter analyze
- flutter test
- flutter build apk --debug

Ambiente: ubuntu-latest
Compatível com repositórios desenvolvidos em Windows, macOS ou Linux.

👨‍💻 Autor

Augusto Ferreira @augusto49

Desafio Técnico Flutter — GastroGo (2025)
