//
//  Reachability.swift
//  ehss
//
//  Created by IOS1-PC on 4/15/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import Foundation
import SystemConfiguration


public enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    public var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

public enum ReachabilityStatus: CustomStringConvertible  {
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
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}



/*
 class func isConnectedToNetwork() -> Bool {
 var zeroAddress = sockaddr_in()
 zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
 zeroAddress.sin_family = sa_family_t(AF_INET)
 let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
 SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
 }
 var flags = SCNetworkReachabilityFlags()
 if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
 return false
 }
 let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
 let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
 return (isReachable && !needsConnection)
 }
 */
