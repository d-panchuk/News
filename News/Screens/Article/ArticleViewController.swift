//
//  ArticleViewController.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController, Storyboarded {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var publishTimeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    // MARK: Properties
    var viewModel: ArticleScreenViewModel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        updateUI()
    }
    
    // MARK: Actions
    @IBAction private func readMoreButtonTapped(sender: UIButton) {
        guard let url = viewModel.linkURL else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func shareButtonTapped(sender: AnyObject) {
        let activityViewController = UIActivityViewController(
            activityItems: [viewModel.linkURL as Any], applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
    
    // MARK: Private methods
    private func setup() {
        readMoreButton.backgroundColor = .black
        readMoreButton.layer.cornerRadius = 5
        readMoreButton.tintColor = .white
        readMoreButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped(sender:))
        )
    }
    
    private func updateUI() {
        titleLabel.text = viewModel.title
        imageView.setImage(from: viewModel.imageUrlPath)
        sourceLabel.text = viewModel.source
        publishTimeLabel.text = viewModel.publishTime
        contentLabel.text = viewModel.content
    }
    
}
