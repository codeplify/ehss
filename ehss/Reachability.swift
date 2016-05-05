//
//  Reachability.swift
//  ehss
//
//  Created by IOS1-PC on 4/15/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import Foundation
import SystemConfiguration


public enum ReachabilityType: Printable {
    case WWAN
    case WiFi
    
    public var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

public enum ReachabilityStatus: Printable  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    public var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}


/**
:see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
*/
public class Reach {
    
    public class func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return .Unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
}

extension ReachabilityStatus {
    private init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let isWWAN = (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}