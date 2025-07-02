## 🚀 Funcionalidades

- ✅ Adicionar itens à lista.
- ✅ Editar itens existentes.
- ✅ Marcar itens como "comprados" com check visual.
- ✅ Remover itens da lista com swipe.
- ✅ Mensagem central indicando lista vazia.
- ✅ Dados persistidos localmente com Core Data.
- ✅ Interface construída 100% com ViewCode (sem Storyboard).
- ✅ Visual simples e didático.

---

## 🛠 Tecnologias e Conceitos Utilizados

### 🔹 Swift + UIKit
- Criação de telas com **ViewCode**, sem Storyboard.
- Navegação utilizando **UINavigationController**.
- Uso de **UITableView** para exibição da lista.

### 🔹 Persistência de Dados
- **Core Data** como solução robusta para salvar, buscar e manipular dados localmente.
- Criação de modelo no `.xcdatamodeld`.
- Manipulação do contexto com `NSManagedObjectContext`.

### 🔹 Boas Práticas de Código
- Separação de responsabilidades: Modelos de dados, Células customizadas e ViewController.
- Uso de `UIAlertController` para entrada e edição de dados.
- Implementação de Empty State quando a lista está vazia.
- Implementação de swipe actions para editar e deletar itens.
- Atualização eficiente da interface com `reloadRows` e `deleteRows`.
