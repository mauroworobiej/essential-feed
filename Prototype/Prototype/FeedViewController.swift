//
//  FeedViewController.swift
//  Prototype
//
//  Created by Mauro Worobiej on 01/05/2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {addSubview($0)}
    }
}

class FeedCell: UITableViewCell {
    static let identifier = "feedCell"
    
    private lazy var locationImageView: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        img.tintColor = .lightGray
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var locationImageContainer: UIView = {
        let view = UIView()
        view.addSubview(locationImageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location\nLocation"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            locationImageContainer,
            locationLabel
        ])
        container.alignment = .top
        container.spacing = 26
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var feedImageView: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "camera"))
        img.tintColor = .lightGray
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var feedImageContainer: UIView = {
        let view = UIView()
        view.addSubview(feedImageView)
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla luctus, nulla ut commodo consequat, risus neque consectetur erat, ac efficitur tortor diam in libero. Pellentesque suscipit porttitor venenatis. Nullam bibendum tellus a felis facilisis, vel luctus neque maxim"
        label.textColor = .black.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cellContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            locationContainer,
            feedImageContainer,
            descriptionLabel
        ])
        container.spacing = 10
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        setupView()
    }
    
}

extension FeedCell {
    private func setupView() {
        setupAdditionalConfigs()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupAdditionalConfigs() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func setupViewHierarchy() {
        addSubview(cellContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            cellContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cellContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            locationImageContainer.widthAnchor.constraint(equalToConstant: 2),

            locationImageView.topAnchor.constraint(equalTo: locationImageContainer.topAnchor, constant: 3),
            locationImageView.leadingAnchor.constraint(equalTo: locationImageContainer.leadingAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationContainer.widthAnchor.constraint(equalTo: cellContainer.widthAnchor),
            
            feedImageContainer.widthAnchor.constraint(equalTo: cellContainer.widthAnchor),
            feedImageContainer.heightAnchor.constraint(equalTo: feedImageView.widthAnchor),

            feedImageView.topAnchor.constraint(equalTo: feedImageContainer.topAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: feedImageContainer.leadingAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: feedImageContainer.trailingAnchor),
            feedImageView.bottomAnchor.constraint(equalTo: feedImageContainer.bottomAnchor),
            
            
            
            
            
        ])
    }
}

class FeedViewController: UIViewController {
    
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

// MARK: - TableView DataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier) as? FeedCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
}


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
