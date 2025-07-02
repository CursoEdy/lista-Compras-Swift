//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by ednardo alves on 30/06/25.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController {
    
    //Acessar o context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var items: [ShoppingItem] = []
    
    private let tableView = UITableView()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Sua lista de compras está vazia."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Adicionar item", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupConstraints()
        updateEmptyState()
        loadItems()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Lista de compras"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShoppingItemCell.self, forCellReuseIdentifier: ShoppingItemCell.identifier)
        
        [tableView, emptyStateLabel, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addButton.addTarget(self , action: #selector(addItemTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
    }
    
    @objc private func addItemTapped() {
        let alert = UIAlertController(title: "Novo item", message: "Digite o item que deseja comprar", preferredStyle: .alert)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self] _ in
            
            guard let self = self, let itemName = alert.textFields?.first?.text, !itemName.isEmpty else { return }
            
            let newItem = ShoppingItem(context: self.context)
            newItem.name = itemName
            newItem.isPurchased = false
            
            self.items.append(newItem)
            self.saveContext()
            self.tableView.reloadData()
            self.updateEmptyState()
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar no core data: \(error)")
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !items.isEmpty
    }
    
    private func loadItems() {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        
        do {
            items = try context.fetch(request)
            tableView.reloadData()
            updateEmptyState()
        } catch {
            print("Erro ao buscar itens: \(error)")
        }
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingItemCell.identifier, for: indexPath) as? ShoppingItemCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isPurchased.toggle()
        saveContext()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            self?.presentEditAlert(for: indexPath.row)
            completion(true)
        }
    
        editAction.backgroundColor = .systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            let itemToDelete = self.items[indexPath.row]
            self.context.delete(itemToDelete)
            self.items.remove(at: indexPath.row)
            
            self.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateEmptyState()
            
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func presentEditAlert(for index: Int) {
        let item = items[index]
        let alert = UIAlertController(title: "Edite Item", message: "Atualize o nome do item", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = item.name
        }
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { [weak self] _ in
            guard let self = self, let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            
            item.name = newName
            self.saveContext()
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
}
