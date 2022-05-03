//
//  FeedCell.swift
//  Prototype
//
//  Created by Mauro Worobiej on 02/05/2022.
//

import UIKit

class FeedCell: UITableViewCell {
    static let identifier = "feedCell"
    
    private lazy var locationImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "pin"))
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
        container.spacing = 6
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var feedImageView: UIImageView = {
        let img = UIImageView()
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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.alpha = 0
    }
    
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        
        fadeIn(UIImage(named: model.imageName))
    }
    
    private func fadeIn(_ image: UIImage?) {
        feedImageView.image = image
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            options: [],
            animations: {
                self.feedImageView.alpha = 1
            })
    }
}

// MARK: - Setup FeedCell View

extension FeedCell {
    private func setupView() {
        setupAdditionalConfigs()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupAdditionalConfigs() {
        backgroundColor = .white
        selectionStyle = .none
        feedImageView.alpha = 0
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

            locationImageContainer.widthAnchor.constraint(equalToConstant: 10),

            locationImageView.topAnchor.constraint(equalTo: locationImageContainer.topAnchor, constant: 3),
            locationImageView.leadingAnchor.constraint(equalTo: locationImageContainer.leadingAnchor),
            locationImageView.heightAnchor.constraint(equalToConstant: 14),
            
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
