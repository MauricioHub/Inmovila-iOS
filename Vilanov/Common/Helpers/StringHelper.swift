//
//  StringHelper.swift
//  Vilanov
//
//  Created by andres on 2/26/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//
import UIKit
import Foundation

extension String {
    var first: String {
        return String(prefix(1))
        //        return String(characters.prefix(1))
    }
    var last: String {
        return String(suffix(1))
        //        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
        //        return first.uppercased() + String(characters.dropFirst())
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    //MARK: - HTML TO TEXT
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding:String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black, NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "AvenirNext-Medium", size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,
                                                       NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let normalString = NSMutableAttributedString(string:text, attributes:attrs)
        self.append(normalString)
        return self
    }
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

/*
 USAGE:
 et sentence = "Out of this world!!!"
 let words = sentence.byWords             // ["Out", "of", "this", "world"]
 let firstWord = words.first      // "Out"
 let lastWord = words.last         // world"
 let first2Words = words.prefix(2) // ["Out", "of"]
 let last2Words = words.suffix(2)   // ["this", "world"]
 */
extension StringProtocol where Index == String.Index {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
