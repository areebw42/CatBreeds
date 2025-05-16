//
//  String+Extension.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/7/25.
//


extension String {
    func removeChar(delimiters: String) -> String {
        let finalString = self
        for delimiter in delimiters {
            if let index = finalString.firstIndex(of: delimiter) {
                return String(finalString[..<index])

            }
        }
        return finalString
    }
}

