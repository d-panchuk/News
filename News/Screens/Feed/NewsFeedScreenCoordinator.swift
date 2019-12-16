//
//  NewsFeedScreenCoordinator.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

final class NewsFeedScreenCoordinator: BaseCoordinator {
    
    // MARK: Properties
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var onFinish: (() -> Void)?
    let disposeBag = DisposeBag()
    
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
        let viewModel = NewsFeedViewModel()
        feedVC.viewModel = viewModel
        
        viewModel.showArticle
            .subscribe(onNext: { [weak self] in self?.showArticleViewController(of: $0) })
            .disposed(by: disposeBag)
        
        return feedVC
    }
    
    private func showArticleViewController(of model: ArticleViewModel) {
        let articleVC = ArticleViewController.instantiate()
        articleVC.viewModel = ArticleScreenViewModel(model: model)
        presenter.pushViewController(articleVC, animated: true)
    }
    
}
