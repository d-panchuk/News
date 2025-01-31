//
//  ErrorPresenter.swift
//  News
//
//  Created by Dima Panchuk on 19.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import Combine

final class ErrorPresenter {
    private let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    private var presentedError: String?
    
    var dismissed: AnyPublisher<Void, Never>
    
    init() {
        let dismissSubject = PassthroughSubject<Void, Never>()
        
        self.dismissed = dismissSubject.eraseToAnyPublisher()
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            dismissSubject.send(Void())
            self?.presentedError = nil
        }
        
        alertController.addAction(okAction)
    }
    
    func present(error: String?, on viewController: UIViewController) {
        guard presentedError == nil else {
            return
        }
        
        presentedError = error
        alertController.title = "Error"
        alertController.message = error
        viewController.present(alertController, animated: true)
    }
}
