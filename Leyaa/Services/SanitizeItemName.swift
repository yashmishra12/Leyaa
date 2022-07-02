//
//  SanitizeItemName.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/23/22.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

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
        
        let alphanumeric = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "l", "k", "j", "h", "g", "f", "d", "s", "a", "z", "x", "c", "v", "b", "n", "m", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        
        if assetList.contains(trimmedStr) {
            return trimmedStr
        }else {
            let firstLetter = trimmedStr[0..<1]
            if alphanumeric.contains(firstLetter) { return firstLetter}
            else
                {return "imageNotFound"}
        }
        
        
    }

}
