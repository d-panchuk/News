//
//  NewsFeedViewController.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import Combine

final class NewsFeedViewController: UIViewController, Storyboarded {
    
    struct Props {
        let articles: [ArticleViewModel]
        let isReloading: Bool
        let errorMessage: String?
    }
    
    // MARK: Outlets & UI elements
    @IBOutlet private weak var articlesTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let errorPresenter = ErrorPresenter()
    
    // MARK: Properties
    var viewModel: NewsFeed.ViewModel!
    var onArticleSelect: ((ArticleViewModel) -> Void)?
    
    @Published private var selectedArticleIndex: Int?
    
    private var dataSource: UITableViewDiffableDataSource<Section, ArticleViewModel>?
    private var renderedProps: Props?
    private var cancellables = Set<AnyCancellable>()
    
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
        
        articlesTableView.delegate = self
        configureDataSource()
    }
    
    private func initRefreshControl() {
        articlesTableView.insertSubview(refreshControl, at: 0)
    }
    
    private func initBindings() {
        let didPullToRefresh = refreshControl.publisher(for: .valueChanged)
            .map { _ in Void() }
            .eraseToAnyPublisher()
        
        let contentOffsetDidChange = articlesTableView.publisher(for: \.contentOffset)
            .map { [unowned self] _ in self.articlesTableView.isNearBottomEdge() }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let outputs = viewModel.makeOutputs(from:
            NewsFeed.ViewModel.Inputs(
                pullToRefresh: didPullToRefresh,
                contentOffsetChange: contentOffsetDidChange,
                articleSelect: $selectedArticleIndex.compactMap{ $0 }.eraseToAnyPublisher()
            )
        )
        
        outputs.props
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in self.render(props: $0) })
            .store(in: &cancellables)
        
        outputs.route
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] route in
                switch route {
                case let .articleDetails(article):
                    self.onArticleSelect?(article)
                }
            })
            .store(in: &cancellables)
        
        outputs.stateChanges
            .sink(receiveValue: {})
            .store(in: &cancellables)
    }
    
}

// MARK: - DataSource
enum Section: CaseIterable {
    case main
}

typealias ArticlesSnapshot = NSDiffableDataSourceSnapshot<Section, ArticleViewModel>

extension NewsFeedViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ArticleViewModel>(tableView: articlesTableView) {
                (tableView: UITableView, indexPath: IndexPath, articleViewModel: ArticleViewModel) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath
            ) as? ArticleTableViewCell
            
            let props = NewsFeed.makeArticleCellProps(from: articleViewModel)
            cell?.renderProps(props)
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate
extension NewsFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleIndex = indexPath.row
    }

}

// MARK: - Props Rendering
extension NewsFeedViewController {
    
    private func render(props: Props) {
        if renderedProps?.articles != props.articles {
            let snapshot = makeSnapshot(from: props.articles)
            dataSource?.apply(snapshot)
        }
        
        if renderedProps?.isReloading != props.isReloading {
            toggleRefreshControlLoading(to: props.isReloading)
        }
        
        if let errorMessage = props.errorMessage, renderedProps?.errorMessage != errorMessage {
            errorPresenter.present(error: errorMessage, on: self)
        }
        
        renderedProps = props
    }
    
    private func makeSnapshot(from articles: [ArticleViewModel]) -> ArticlesSnapshot {
        var snapshot = ArticlesSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles, toSection: .main)
        return snapshot
    }
    
    private func toggleRefreshControlLoading(to state: Bool) {
        state ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
    }
    
}
