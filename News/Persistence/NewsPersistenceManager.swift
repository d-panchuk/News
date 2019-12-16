//
//  NewsPersistenceManager.swift
//  News
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import CoreData

struct NewsPersistenceManager {
        
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.context
    }
    
    func saveArticlesIfNeeded(_ articles: [ArticleDTO]) {
        let candidateIds = articles.map { $0.id }
        let cachedIds = getArticleEntitiesWithIds(from: candidateIds).compactMap { $0.id }
        let articleIdsToSave = candidateIds.diff(from: cachedIds)

        for article in articles where articleIdsToSave.contains(article.id) {
            let entity = ArticleEntity(context: context)
            article.setupArticleEntity(entity)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func saveArticleIds(_ articleIds: [String], for query: String, page: Int) {
        let entity = QueryEntity(context: context)
        entity.query = query
        entity.page = Int16(page)
        entity.articleIds = articleIds
        CoreDataManager.shared.saveContext()
    }
    
    func getArticles(for query: String, page: Int) -> [ArticleEntity] {
        let predicate = NSPredicate(format: "query = %@ AND page = \(page)", query)
        let queryFetchResult = getQueryEntities(using: predicate)
        guard let articleIds = queryFetchResult.first?.articleIds else { return [] }
        return getArticleEntitiesWithIds(from: articleIds)
    }
    
    func getTotalResults(for query: String) -> Int {
        let predicate = NSPredicate(format: "query == %@ AND page == max(page)", query)
        let categoryFetchResult = getQueryEntities(using: predicate)
        
        if let lastPage = categoryFetchResult.first,
            let lastPageArticlesCount = lastPage.articleIds?.count
        {
            let previousPagesArticlesCount = (Int(lastPage.page) - 1) * AppConstants.Network.pageSize
            return previousPagesArticlesCount + lastPageArticlesCount
        }
        
        return 0
    }
}

extension Array where Element: Hashable {
    
    func diff(from other: [Element]) -> [Element] {
        let selfSet = Set(self)
        let otherSet = Set(other)
        return Array(selfSet.symmetricDifference(otherSet))
    }
    
}

// MARK: - Helpers
private extension NewsPersistenceManager {
    
    func getArticleEntitiesWithIds(from articleIds: [String]) -> [ArticleEntity] {
        let predicate = NSPredicate(format: "id IN %@", articleIds)
        return getArticleEntities(using: predicate)
    }
    
    func getQueryEntities(using predicate: NSPredicate? = nil) -> [QueryEntity] {
        let fetchRequest = NSFetchRequest<QueryEntity>(entityName: "QueryEntity")
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
    func getArticleEntities(using predicate: NSPredicate? = nil) -> [ArticleEntity] {
        let fetchRequest = NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
}

