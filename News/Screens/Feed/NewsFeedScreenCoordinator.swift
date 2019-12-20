//
//  NewsFeedScreenCoordinator.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension NewsFeed {
    
    final class ScreenCoordinator: BaseCoordinator {
        
        // MARK: Properties
        var presenter: UINavigationController
        var childCoordinators: [Coordinator]
        var onFinish: (() -> Void)?
        
        // MARK: Initializers
        init(presenter: UINavigationController) {
            self.presenter = presenter
            self.childCoordinators = []
        }
        
        // MARK: Public methods
        func start() {
            let feedVC = makeFeedViewController()
            presenter.pushViewController(feedVC, animated: true)
        }
        
        // MARK: Private methods
        private func makeFeedViewController() -> NewsFeedViewController {
            let feedVC = NewsFeedViewController.instantiate()
            let viewModel = NewsFeed.ViewModel()
            feedVC.viewModel = viewModel
            feedVC.onArticleSelect = { [weak self] article in
                self?.showArticleViewController(of: article)
            }
            
            return feedVC
        }
        
        private func showArticleViewController(of model: ArticleViewModel) {
            let articleVC = ArticleViewController.instantiate()
            let articleProps = makeArticleProps(from: model)
            _ = articleVC.view // FIXME
            articleVC.renderProps(articleProps)
            presenter.pushViewController(articleVC, animated: true)
        }
        
        private func makeArticleProps(from model: ArticleViewModel) -> ArticleViewController.Props {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = AppConstants.Network.dateFormat
            let publishDate = dateFormatter.date(from: model.publishedAt)
            
            return ArticleViewController.Props(
                title: model.title,
                imageUrlPath: model.urlToImage,
                source: model.sourceName,
                publishTime: publishDate?.getElapsedTime() ?? "",
                content: model.content ?? "",
                linkURL: URL(string: model.url)
            )
        }
        
    }
    
}
