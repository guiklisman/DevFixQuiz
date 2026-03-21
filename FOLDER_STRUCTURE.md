# Estrutura de Pastas do Projeto

Este documento explica a organização de pastas do `DevQuizFix`, seguindo os princípios de **Clean Architecture** e **MVVM**.

## 📁 /lib
A raiz de todo o código fonte do Flutter.

### 📁 /core
Contém recursos que são compartilhados por todo o app e não pertencem a uma funcionalidade (feature) específica.
- **📁 /exceptions**: Definições de erros customizados (ex: `AppException`).
- **📁 /services**: Serviços globais do sistema (ex: `NotificationService`).

### 📁 /domain
O "coração" do app. Contém a lógica de negócio pura, independente de frameworks ou plugins.
- **📁 /entities**: Objetos de dados puros (Ex: `QuizItem`).
- **📁 /repositories**: Interfaces (contratos) que definem como os dados devem ser acessados sem dizer *como* (Ex: `IQuizRepository`).

### 📁 /data
Implementação da camada de dados. É aqui que o app conversa com o mundo externo (JSON, APIs, Banco de Dados).
- **📁 /models**: Extensões das entidades com lógica de serialização (Ex: `QuizItemModel.fromJson`).
- **📁 /repositories**: Implementações concretas dos contratos definidos no Domain (Ex: `QuizRepository`).
- **📁 /services**: Serviços de infraestrutura específicos (Ex: `JsonService` para ler arquivos, `SharedPrefsService` para persistência local).

### 📁 /ui
Camada de apresentação (Interface do Usuário). Organizada seguindo o padrão MVVM.
- **📁 /core**:
    - **📁 /theme**: Centralização de cores e estilos (`AppTheme`, `AppColors`).
    - **📁 /widgets**: Componentes reutilizáveis que não possuem lógica de estado própria (Ex: `OptionTile`, `AppBackground`).
- **📁 /features**: Organizado por funcionalidades do app (Ex: `/home`):
    - **📁 /view_model**: O cérebro da tela. Gerencia o estado e as ações do usuário.
    - **📁 /views**: A interface visual (Screens). Devem ser o mais "burras" possível, apenas observando o ViewModel.

---

## 📄 Arquivos na Raiz
- `main.dart`: Ponto de entrada do app e configuração da Injeção de Dependência (Providers).
- `README.md`: Visão geral do projeto para desenvolvedores externos.
- `TODO.md`: Lista de tarefas e progresso do desenvolvimento.
- `FOLDER_STRUCTURE.md`: Este guia de organização.

---

## 🛠️ Regra de Ouro da Arquitetura
1. **Domain** não conhece ninguém.
2. **Data** conhece o Domain.
3. **UI** conhece o Domain e o ViewModel.
4. **ViewModel** conhece o Domain (através das interfaces de Repositório).

Seguir esta estrutura garante que o código seja fácil de testar, manter e escalar!
