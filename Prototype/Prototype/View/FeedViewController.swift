//
//  FeedViewController.swift
//  Prototype
//
//  Created by Mauro Worobiej on 01/05/2022.
//

import UIKit

class FeedViewController: UIViewController {
    private let feed = FeedImageViewModel.prototypeFeed
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        let footerAndHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.width, height: 16))
        table.tableHeaderView = footerAndHeaderView
        table.tableFooterView = footerAndHeaderView
        table.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup FeedViewController View
extension FeedViewController {
    
    private func setupView() {
        setupAdditionalConfigs()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupAdditionalConfigs() {
        view.backgroundColor = .white
        title = "My Feed"
    }
    
    private func setupViewHierarchy() {
        view.addSubviews(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - TableView DataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier) as? FeedCell else {
            return UITableViewCell()
        }
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
