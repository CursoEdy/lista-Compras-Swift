//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by ednardo alves on 30/06/25.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    private var items: [String] = [] {
        didSet {
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Lista de compras"
        tableView.delegate = self
        tableView.dataSource = self
        
        [tableView, emptyStateLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !items.isEmpty
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
