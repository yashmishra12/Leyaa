//
//  SanitizeItemName.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/23/22.
//

import Foundation

extension String {

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
        let assetList = ["apple", "banana", "cheese", "capsicum", "milk", "egg", "carrot", "tomato", "bread"]
   
        let itName = self.lowercased()
        if assetList.contains(itName) {
            return itName
        }else {
            let firstLetter = itName[0..<1]
            return firstLetter
        }
        
        
    }


}
