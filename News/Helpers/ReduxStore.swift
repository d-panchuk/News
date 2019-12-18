//
//  ReduxStore.swift
//  ReTweet
//
//  Created by Arthur Myronenko on 10/12/18.
//  Copyright © 2018 Arthur Mironenko. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReduxStore<State, Action> {
    
    typealias Reducer = (State, Action) -> State
    typealias Dispatch = (Action) -> Void
    typealias StateProvider = () -> State
    typealias Middleware = (@escaping Dispatch, @escaping StateProvider) -> (@escaping Dispatch) -> Dispatch
    
    let state: Observable<State>
    private let stateRelay: BehaviorRelay<State>
    private let reducer: Reducer
    private var dispatchFunction: Dispatch!
    
    init(
        initialState: State,
        reducer: @escaping Reducer,
        middlewares: [Middleware]
    ) {
        let stateRelay = BehaviorRelay(value: initialState)
        let defaultDispatch: Dispatch = { action in
            let newState = reducer(stateRelay.value, action)
            stateRelay.accept(newState)
        }
        
        self.stateRelay = stateRelay
        self.state = stateRelay.asObservable()
        self.reducer = reducer
        self.dispatchFunction = middlewares
            .reversed()
            .reduce(defaultDispatch) { (dispatchFunction, middleware) -> Dispatch in
                let dispatch: Dispatch = { [weak self] in self?.dispatch(action: $0) }
                let getState: StateProvider = { stateRelay.value }
                return middleware(dispatch, getState)(dispatchFunction)
        }
    }
    
    func dispatch(action: Action) {
        dispatchFunction?(action)
    }
    
    func getState() -> State {
        return stateRelay.value
    }
    
    static func makeMiddleware(worker: @escaping (@escaping Dispatch, StateProvider, Dispatch, Action) -> Void) -> Middleware {
        return { dispatch, getState in { next in { action in worker(dispatch, getState, next, action) } } }
    }
}

