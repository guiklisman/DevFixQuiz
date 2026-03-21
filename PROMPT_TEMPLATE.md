# Prompt para Início de Projeto (Arquitetura Clean + MVVM)

Copie e cole este prompt para iniciar um novo projeto seguindo a mesma estrutura rigorosa que aplicamos no `DevQuizFix`.

---

**Prompt:**

"Olá! Vamos iniciar um novo projeto Flutter. Quero que você siga rigorosamente a arquitetura **Clean Architecture** combinada com **MVVM** e as seguintes regras de desenvolvimento:

### 1. Estrutura de Pastas Obrigatória
Tudo deve ser organizado dentro da pasta `lib/` da seguinte forma:
- `core/`: Erros globais e serviços de sistema (ex: notificações).
- `domain/entities/`: Classes de dados puras.
- `domain/repositories/`: Interfaces (abstratas) dos repositórios.
- `data/models/`: Modelos com `fromJson`/`toJson` que estendem as entidades.
- `data/repositories/`: Implementações concretas que usam os Models e Services.
- `data/services/`: Serviços de infraestrutura (API, Local Storage, JSON).
- `ui/core/theme/`: Centralização de cores e estilos.
- `ui/core/widgets/`: Componentes visuais reutilizáveis.
- `ui/features/[nome_da_feature]/view_model/`: Lógica de estado da funcionalidade.
- `ui/features/[nome_da_feature]/views/`: Telas (Screens) que observam o ViewModel.

### 2. Regras de Ouro de Código
- **❌ Proibido:** Criar funções que retornam Widgets. Se for um componente reutilizável, crie uma classe `StatelessWidget` ou `StatefulWidget` dedicada.
- **❌ Proibido:** Inserir lógica de negócio ou cálculos complexos dentro dos Widgets. Tudo deve estar no **ViewModel**.
- **✅ Injeção de Dependência:** Use o pacote `provider` (ou similar) no `main.dart` para injetar dependências através dos construtores.
- **✅ Desacoplamento:** A camada de UI e o ViewModel devem conhecer apenas a **Interface** do Repositório (`lib/domain/repositories/`), nunca a implementação concreta.
- **✅ Tema Centralizado:** Use um arquivo `app_theme.dart` para gerenciar todas as cores e estilos do Material Design.

### 3. Workflow de Desenvolvimento
Sempre crie um arquivo `TODO.md` na raiz para listar as tarefas e um `FOLDER_STRUCTURE.md` explicando a arquitetura.

Agora, com base nessas diretrizes, vamos começar a planejar a primeira funcionalidade do meu novo projeto: [DESCREVA SEU PROJETO AQUI]"
