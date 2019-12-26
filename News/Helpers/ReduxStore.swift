//
//  ReduxStore.swift
//  ReTweet
//
//  Created by Arthur Myronenko on 10/12/18.
//  Copyright © 2018 Arthur Mironenko. All rights reserved.
//

import Combine

final class ReduxStore<State, Action> {
    
    typealias Reducer = (State, Action) -> State
    typealias Dispatch = (Action) -> Void
    typealias StateProvider = () -> State
    typealias Middleware = (@escaping Dispatch, @escaping StateProvider) -> (@escaping Dispatch) -> Dispatch
    
    let state: AnyPublisher<State, Never>
    private let stateSubject: CurrentValueSubject<State, Never>
    private let reducer: Reducer
    private var dispatchFunction: Dispatch!
    
    init(
        initialState: State,
        reducer: @escaping Reducer,
        middlewares: [Middleware]
    ) {
        let stateSubject = CurrentValueSubject<State, Never>(initialState)
        let defaultDispatch: Dispatch = { action in
            let newState = reducer(stateSubject.value, action)
            stateSubject.send(newState)
        }
        
        self.stateSubject = stateSubject
        self.state = stateSubject.eraseToAnyPublisher()
        self.reducer = reducer
        self.dispatchFunction = middlewares
            .reversed()
            .reduce(defaultDispatch) { (dispatchFunction, middleware) -> Dispatch in
                let dispatch: Dispatch = { [weak self] in self?.dispatch(action: $0) }
                let getState: StateProvider = { stateSubject.value }
                return middleware(dispatch, getState)(dispatchFunction)
        }
    }
    
    func dispatch(action: Action) {
        dispatchFunction?(action)
    }
    
    func getState() -> State {
        return stateSubject.value
    }
    
    static func makeMiddleware(worker: @escaping (@escaping Dispatch, StateProvider, Dispatch, Action) -> Void) -> Middleware {
        return { dispatch, getState in { next in { action in worker(dispatch, getState, next, action) } } }
    }
}

