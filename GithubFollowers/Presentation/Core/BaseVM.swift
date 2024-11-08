//
//  BaseVM.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 07/10/2024.
//

import Foundation
import Combine

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

class BaseVM {
    @Published var loadState: LoadState = .idle
    
    var bindings = Set<AnyCancellable>()
}
