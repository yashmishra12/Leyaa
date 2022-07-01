//
//  SanitizeItemName.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/23/22.
//

import Foundation

extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }

    subscript(_ range: CountableRange<Int>) -> String {
           let start = index(startIndex, offsetBy: max(0, range.lowerBound))
           let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                                range.upperBound - range.lowerBound))
           return String(self[start..<end])
       }

       subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
           let start = index(startIndex, offsetBy: max(0, range.lowerBound))
            return String(self[start...])
       }

    func sanitiseItemName() -> String {
        let assetList = assetName
   
        let itName = self.lowercased().stripped
        var trimmedStr = itName.filter {!$0.isWhitespace}
        let lastLetter = trimmedStr.last
        
        if(lastLetter == "s") {
            trimmedStr.removeLast()
        }
        
        
        
        if assetList.contains(trimmedStr) {
            return trimmedStr
        }else {
            let firstLetter = trimmedStr[0..<1]
            if assetList.contains(firstLetter) { return firstLetter}
            else
                {return "imageNotFound"}
        }
        
        
    }

}
