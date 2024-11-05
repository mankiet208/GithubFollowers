//
//  Double+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 28/10/2024.
//

import Foundation

extension Double {
    
    func roundToDecimal(digits: Int) -> Double {
        let multiplier = pow(10, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
