//
//  UIScrollView+EdgeDetection.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func isNearBottomEdge(edgeOffset: CGFloat = 20) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
}
