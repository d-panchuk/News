//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell, Reusable {

    struct Props {
        let imageUrlPath: String?
        let title: String
        let description: String?
    }
    
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
    func renderProps(_ props: Props) {
        _imageView.setImage(from: props.imageUrlPath)
        titleLabel.text = props.title
        descriptionLabel.text = props.description
    }
    
}
