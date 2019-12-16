//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell, Reusable {

    // MARK: Outlets
    @IBOutlet private weak var _imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        _imageView.cancelImageLoading()
    }
    
    // MARK: Public methods
    func configure(from viewModel: ArticleViewModel) {
        _imageView.setImage(from: viewModel.urlToImage)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
    
}
