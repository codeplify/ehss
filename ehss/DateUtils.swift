//
//  DateUtils.swift
//  ehss
//
//  Created by IOS1-PC on 4/1/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import Foundation

extension NSDate {
    
    // -> Date System Formatted Medium
    func ToDateMediumString() -> NSString? {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle;
        formatter.timeStyle = .NoStyle;
        return formatter.stringFromDate(self)
    }
    
    
    func toTimeMediumString() -> NSString?{
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .MediumStyle
        return formatter.stringFromDate(self)
    }
}