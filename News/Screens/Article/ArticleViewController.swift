//
//  ArticleViewController.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController, Storyboarded {

    struct Props {
        let title: String
        let imageUrlPath: String?
        let source: String
        let publishTime: String
        let content: String
        let linkURL: URL?
    }
    
    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var publishTimeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    // MARK: Properties
    private var renderedProps: Props?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: Actions
    @IBAction private func readMoreButtonTapped(sender: UIButton) {
        guard let url = renderedProps?.linkURL else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func shareButtonTapped(sender: AnyObject) {
        guard let linkURL = renderedProps?.linkURL else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [linkURL], applicationActivities: nil
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
    
    // MARK: Public methods
    func renderProps(_ props: Props) {
        titleLabel.text = props.title
        imageView.setImage(from: props.imageUrlPath)
        sourceLabel.text = props.source
        publishTimeLabel.text = props.publishTime
        contentLabel.text = props.content
        
        renderedProps = props
    }
    
}
