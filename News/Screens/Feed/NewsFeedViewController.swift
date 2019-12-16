//
//  NewsFeedViewController.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

final class NewsFeedViewController: UIViewController, Storyboarded {

    // MARK: Outlets & UI elements
    @IBOutlet private weak var articlesTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: Properties
    var viewModel: NewsFeedViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: Private methods
    private func setup() {
        initArticlesTableView()
        initRefreshControl()
        initBindings()
    }
    
    private func initArticlesTableView() {
        articlesTableView.tableFooterView = UIView(frame: .zero)
        articlesTableView.register(
            UINib(nibName: "ArticleTableViewCell", bundle: nil),
            forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier
        )
    }
    
    private func initRefreshControl() {
        refreshControl.sendActions(for: .valueChanged)
        articlesTableView.insertSubview(refreshControl, at: 0)
    }

    private func initBindings() {        
        bindViewModelToUI()
        bindUIToViewModel()
        
        articlesTableView.rx.willDisplayCell
            .subscribe(onNext: { UIView.animateAppearence(view: $0.cell, dx: -100) })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToUI() {
        viewModel.articles
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .drive(
                articlesTableView.rx.items(
                    cellIdentifier: ArticleTableViewCell.reuseIdentifier,
                    cellType: ArticleTableViewCell.self)
            ) { (_, articleViewModel, cell) in
                cell.configure(from: articleViewModel)
            }
            .disposed(by: disposeBag)
        
        let errorThrottleInSeconds = RxTimeInterval(3)
        viewModel.errorMessage
            .throttle(errorThrottleInSeconds)
            .drive(onNext: { self.presentAlert(message: $0) })
            .disposed(by: disposeBag)
    }
    
    private func bindUIToViewModel() {
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reloadTrigger)
            .disposed(by: disposeBag)
        
        let articleUpdateThrottleInSeconds = RxTimeInterval(1)
        let articlesTableViewUpdate = articlesTableView.rx.contentOffset
            .throttle(articleUpdateThrottleInSeconds, scheduler: MainScheduler.instance)
            .filter { _ in self.articlesTableView.isNearBottomEdge() }
            .flatMapLatest { _ in Observable.just(()) }
        
        articlesTableViewUpdate
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        articlesTableView.rx.modelSelected(ArticleViewModel.self)
            .bind(to: viewModel.selectArticleTrigger)
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}
