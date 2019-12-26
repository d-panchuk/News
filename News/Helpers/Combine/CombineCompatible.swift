//
//  CombineCompatible.swift
//  News
//
//  Created by Dima Panchuk on 24.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import Combine

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
protocol CombineCompatible { }

extension UIControl: CombineCompatible { }

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}
