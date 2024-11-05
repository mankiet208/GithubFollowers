//
//  Date+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import Foundation

extension Date {
    
    func convertToString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
