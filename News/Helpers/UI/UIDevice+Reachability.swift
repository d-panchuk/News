//
//  UIDevice.swift
//  News
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit
import SystemConfiguration

extension UIDevice {
    
    static var isConnectedToNetwork: Bool {
        let reachability = SCNetworkReachabilityCreateWithName(nil, "News")
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
}
