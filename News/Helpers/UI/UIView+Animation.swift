//
//  UIView+Animation.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension UIView {
    
    static func animateAppearence(view: UIView, dx: CGFloat = 0, dy: CGFloat = 0, dz: CGFloat = 0) {
        view.alpha = 0
        view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, dx, dy, dz)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                view.alpha = 1
                view.layer.transform = CATransform3DIdentity
            }
        )
    }
    
}
