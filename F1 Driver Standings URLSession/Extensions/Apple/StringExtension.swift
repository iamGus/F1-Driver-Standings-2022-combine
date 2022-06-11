//
//  StringExtension.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

extension String {
    
    func localised(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
