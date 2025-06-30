//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by ednardo alves on 30/06/25.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Lista de compras"
    }
}
