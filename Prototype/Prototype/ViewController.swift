//
//  ViewController.swift
//  Prototype
//
//  Created by Mauro Worobiej on 01/05/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }


}

extension ViewController {
    private func setupView() {
        setupAdditionalConfigs()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupAdditionalConfigs() {
        view.backgroundColor = .white
    }
    
    private func setupViewHierarchy() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
