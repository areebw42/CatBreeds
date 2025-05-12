//
//  String+Extension.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/7/25.
//


extension String {
    func removeChar(delimiters: String) -> String {
        var finalString = self
        for delimiter in delimiters {
            if finalString.contains(delimiter) {
                //remove all occurences of the delimiter char
                finalString = finalString.replacingOccurrences(of: String(delimiter), with: "")
            }
        }
        return finalString
    }
}