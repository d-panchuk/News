# News

It's portrait iOS application working with [News API](https://newsapi.org/).
Note: it's possible to discover only 100 news per session since api key of free plan is used.

## How to run

1. Run `pod install` in terminal from project directory.
2. Open `News.xcworkspace` in Xcode.
3. Run project.

## Screens

* **News Feed**: get familiar with news on topic "bitcoin".
* **Article**: check out extended information about specific news article. 

Implemented features: pull to refresh, pagination, offline mode, alerts on network errors.

## Architecture

* MVVM as the main design pattern
* RxSwift & RxCocoa for binding between View and ViewModel layers
* Coordinators to separate navigation logic from View and ViewModel layers
* CoreData for data persistence
* Network layer with the ability to flexibly change implementations

Network layer details:
* RequestType – represent the requirements for a specific request, such as endpoint, method, parameters and headers. They are grouped in RequestData struct for convenience.
* NetworkDispatcher – dispatches request and handles response by identifying error or getting result data as Data. URLSessionNetworkDispatcher is basic implementation of NetworkDispatcher which utilizes URLSession.
* NetworkManager – executes specific request by firstly delegating dispatching of the request to NetworkDispatcher; then (on completion of dispatching) it performs decoding of returned Data into specific model object
* NewsApi – creates and delegates NewsAPI-specific requests to NetworkManager. Result type of request is inferred at the point of calling execute(request:) method.

Dispatcher is interchangeable, so it's possible to use another implementation, as long as it conforms to NetworkDispatcher protocol.
Also, NetworkLogger service is used to debug requests and their responses conveniently.

DataSource details:
* DataSource protocol represents the requirements for news data fetchers. 
* RemoteDataSource – fetches news using Internet requests, then caches them using NewsPersistenceManager (abstraction over CoreData).
* LocalDataSource – fetches cached news from local SQLite database, again using NewsPersistenceManager.
* CacheableDataSource – combination of Remote- and LocalDataSource; uses first when Internet connection is established, and second otherwise.

## Other

Tools used: Xcode 11, Swift 5.
Third-party dependencies: RxSwift, RxCocoa, RxTest, Kingfisher.

## Todo

* Unit-tests
* Fix reentrancy anomaly during offline mode list updating
* Embed Article view components into ScrollView to support landscape orientation 
