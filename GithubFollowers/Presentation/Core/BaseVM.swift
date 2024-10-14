//
//  BaseVM.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation
import Combine

enum LoadState {
    case idle
    case loading
    case loaded
    case error(String)
}

class BaseVM {
    @Published var state: LoadState = .idle
    
    var bindings = Set<AnyCancellable>()
}
