//
//  String+Html.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 8/6/25.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML to AttributedString:", error)
            return nil
        }
    }
    
    func htmlToString() -> Text {
        guard let attrString = htmlToAttributedString() else {
            return Text(self)
        }
        
        let trimmedString = attrString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAttrString = NSAttributedString(string: trimmedString, attributes: attrString.attributes(at: 0, effectiveRange: nil))
        
        var resultText = Text("")
        
        cleanAttrString.enumerateAttributes(in: NSRange(location: 0, length: cleanAttrString.length), options: []) { attributes, range, _ in
            let substring = (cleanAttrString.string as NSString).substring(with: range)
            
            var textSegment = Text(substring)
            
            if let font = attributes[.font] as? UIFont {
                let isBold = font.fontDescriptor.symbolicTraits.contains(.traitBold)
                textSegment = isBold ? textSegment.bold() : textSegment
            }
            
            if let foregroundColor = attributes[.foregroundColor] as? UIColor {
                textSegment = textSegment.foregroundColor(Color(foregroundColor))
            }
            
            resultText = resultText + textSegment
        }
        
        return resultText
    }
    
}

extension String {
    func htmlToPlainString() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let attributed = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        return attributed?.string ?? self
    }
}
