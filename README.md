# Dev Quiz Fixar

Um aplicativo Flutter de Quiz desenvolvido com foco em Clean Architecture, MVVM e melhores práticas de desenvolvimento. O objetivo do app é auxiliar no aprendizado diário através de perguntas interativas e notificações de lembrete.

## 🚀 Tecnologias

- **Flutter**: Framework UI para desenvolvimento multiplataforma.
- **Dart**: Linguagem de programação otimizada para UI.

## 📦 Pacotes Principais

- **[provider](https://pub.dev/packages/provider)**: Gerenciamento de estado e Injeção de Dependência.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)**: Persistência de dados local simples.
- **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)**: Agendamento e exibição de notificações locais.
- **[timezone](https://pub.dev/packages/timezone)**: Manipulação de fusos horários para lembretes precisos.
- **[mockito](https://pub.dev/packages/mockito)**: Utilizado para testes unitários e mocks. (Em desenvolvimento)

## 🏛️ Arquitetura

O projeto segue os princípios da **Clean Architecture** combinados com o padrão **MVVM (Model-View-ViewModel)**, garantindo separação de responsabilidades e testabilidade.

### Estrutura de Pastas
- `lib/domain`: Contém as regras de negócio puras e entidades (`QuizItem`).
- `lib/data`: Implementação de repositórios e serviços de dados (`JsonService`, `SharedPrefsService`).
- `lib/ui`: Camada de apresentação organizada por features:
  - `ui/features`: Contém Views e ViewModels seguindo o padrão MVVM.
  - `ui/core`: Temas globais e widgets compartilhados.
- `lib/core`: Serviços essenciais e utilitários (`NotificationService`, Exceções).

## ✨ Práticas Utilizadas

- **MVVM Puro**: Separação total da lógica de negócio (ViewModel) da interface (View).
- **Widgets Personalizados**: Seguindo a regra de **não utilizar funções que retornam widgets**, todos os componentes complexos foram extraídos para classes dedicadas (`OptionTile`, `QuestionCard`, etc).
- **Tema Centralizado**: Uso de um `AppTheme` dedicado para garantir consistência visual em todo o app.
- **Gerenciamento de Erros**: Implementação de um `ErrorInfoView` unificado para tratamento de falhas globais.
- **Injeção de Dependência**: Uso do `MultiProvider` no `main.dart` para injetar dependências de forma limpa.
- **Immutabilidade**: Uso de métodos como `copyWith` nas entidades para manipulação segura de estado.
- **Código Limpo**: Remoção de comentários redundantes e organização lógica de imports e componentes.

## 🧪 Testes

O projeto está sendo preparado para suportar os três tipos de testes fundamentais no Flutter:
- **Testes Unitários**: Lógica de ViewModels e Repositories.
- **Testes de Widget**: Componentes de UI isolados.
- **Testes de Integração**: Fluxos completos do usuário.

---
Desenvolvido por [guiklisman](https://github.com/guiklisman)
