//
//  String+Common.swift
//  Infini
//
//  Created by Ivan on 19/01/2015.
//  Copyright (c) 2015 France Télévisions. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return characters.count
    }
    
    func replace(search: String, withString: String) -> String {
        return stringByReplacingOccurrencesOfString(search, withString: withString, options: .LiteralSearch)
    }

    subscript (range: Range<Int>) -> String {
        get {
            let subStart = startIndex.advancedBy(range.startIndex, limit: endIndex)
            let subEnd = subStart.advancedBy(range.endIndex - range.startIndex, limit: endIndex)
            return substringWithRange(Range(start: subStart, end: subEnd))
        }
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    func substring(from: Int, length: Int? = nil) -> String {
        if let length = length {
            return self[from..<from + length]
        }
        return substringFromIndex(startIndex.advancedBy(from, limit: endIndex))
    }
    
    func startsWith(search: String) -> Bool {
        if indexOf(search) == 0 {
            return true
        }
        return false
    }
    
    func endsWith(search: String) -> Bool {
        if lastIndexOf(search) == characters.count - search.characters.count {
            return true
        }
        return false
    }
    
    func indexOf(search: String, startIndex index: Int = 0) -> Int? {
        let searchRange = Range(start: startIndex.advancedBy(index), end: endIndex)
        if let range = rangeOfString(search, options: .LiteralSearch, range: searchRange) {
            return startIndex.distanceTo(range.startIndex)
        }
        return nil
    }

    public func lastIndexOf(search: String) -> Int? {
        if let range = rangeOfString(search, options: [.LiteralSearch, .BackwardsSearch]) {
            return startIndex.distanceTo(range.startIndex)
        }
        return nil
    }

    
    func slugify(separator separator: String = "-") -> String? {
        var slugarized: String?
        
        // First conversion to replace most not ASCII characters
        let cfStr = self.mutableCopy()
        var cfRange = CFRangeMake(0, CFStringGetLength(self as CFStringRef))
        CFStringTransform(cfStr as! CFMutableString, &cfRange, kCFStringTransformStripCombiningMarks, false)
        slugarized = String(cfStr)
        
        // Turn non-slug characters into separator
        let nonSlugCharsRegex = try? NSRegularExpression(pattern: "[^a-z0-9]+", options: .CaseInsensitive)
        slugarized = nonSlugCharsRegex?.stringByReplacingMatchesInString(slugarized!, options: [], range: NSRange(location: 0, length: slugarized!.length), withTemplate: separator)

        if slugarized == nil {
            return nil
        }

        // No more than one of the separator in a row
        if separator != "" {
            let repeatingSeparatorsRegex = try? NSRegularExpression(pattern: "\(separator){2,}", options: [])
            slugarized = repeatingSeparatorsRegex?.stringByReplacingMatchesInString(slugarized!, options: [], range: NSRange(location: 0, length: slugarized!.length), withTemplate: separator)

            // Remove leading/trailing separator
            slugarized = slugarized?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: separator))
        }
        
        return slugarized?.lowercaseString
    }
}