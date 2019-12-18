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

    struct Props {
        let articles: [ArticleViewModel]
        let isReloading: Bool
        let errorMessage: String?
    }
    
    // MARK: Outlets & UI elements
    @IBOutlet private weak var articlesTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: Properties
    var viewModel: NewsFeed.ViewModel!
    var onArticleSelect: ((ArticleViewModel) -> Void)?
    
    private var renderedProps: Props?
    private let articlesSubject = BehaviorRelay<[ArticleViewModel]>(value: [])
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
        articlesTableView.rx.willDisplayCell
            .subscribe(onNext: { UIView.animateAppearence(view: $0.cell, dx: -100) })
            .disposed(by: disposeBag)
        
        articlesSubject
            .bind(to: articlesTableView.rx.items(
                cellIdentifier: ArticleTableViewCell.reuseIdentifier,
                cellType: ArticleTableViewCell.self)
            ) { (_, articleViewModel, cell) in
                cell.configure(from: articleViewModel)
            }
            .disposed(by: disposeBag)
    }
    
    private func initRefreshControl() {
        articlesTableView.insertSubview(refreshControl, at: 0)
    }

    private func initBindings() {        
        let articlesTableViewUpdate = articlesTableView.rx.contentOffset
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in self.articlesTableView.isNearBottomEdge() }
            .flatMapLatest { _ in Observable.just(()) }
        
        let outputs = viewModel.makeOutputs(from:
            NewsFeed.ViewModel.Inputs(
                reloadTrigger: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
                nextPageTrigger: articlesTableViewUpdate,
                selectArticleTrigger: articlesTableView.rx.modelSelected(ArticleViewModel.self).asObservable()
            )
        )
        
        outputs.props
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in self.render(props: $0) })
            .disposed(by: disposeBag)
        
        outputs.stateChanges
            .subscribe()
            .disposed(by: disposeBag)
        
        outputs.route
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] route in
                switch route {
                case let .articleDetails(article):
                    self.onArticleSelect?(article)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func render(props: Props) {
        if renderedProps?.articles != props.articles {
            articlesSubject.accept(props.articles)
        }
        
        if renderedProps?.isReloading != props.isReloading {
            toggleRefreshControlLoading(to: props.isReloading)
        }
        
        //.throttle(3)
        if let errorMessage = props.errorMessage, renderedProps?.errorMessage != errorMessage {
            //errorPresenter.present(error: error, on: self)
            presentAlert(message: errorMessage)
        }
        
        renderedProps = props
    }
    
    private func toggleRefreshControlLoading(to state: Bool) {
        state ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}
