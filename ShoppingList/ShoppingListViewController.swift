//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by ednardo alves on 30/06/25.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    private var items: [ShoppingItem] = [] {
        didSet {
            saveItems()
            updateEmptyState()
        }
    }
    
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
            if let itemName = alert.textFields?.first?.text, !itemName.isEmpty {
                let newItem = ShoppingItem(name: itemName, isPurchased: false)
                self?.items.append(newItem)
                self?.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func saveItems() {
        let names = items.map {$0.name}
        let purchased = items.map {$0.isPurchased}
        UserDefaults.standard.set(names, forKey: "itemNames")
        UserDefaults.standard.set(purchased, forKey: "itemPurchased")
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !items.isEmpty
    }
    
    private func loadItems() {
        let names = UserDefaults.standard.stringArray(forKey: "itemNames") ?? []
        let purchased = UserDefaults.standard.array(forKey: "itemPurchased") as? [Bool] ?? []
        
        items = zip(names,purchased).map {ShoppingItem(name: $0, isPurchased: $1)}
        updateEmptyState()
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
        items[indexPath.row].isPurchased.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
