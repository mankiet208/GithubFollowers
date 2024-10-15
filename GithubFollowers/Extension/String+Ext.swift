//
//  String+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import Foundation

extension String {
    
    func convertToDate(with format: String, locale: String = "en_US") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
}
