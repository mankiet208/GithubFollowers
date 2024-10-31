//
//  FollowerListVMTests.swift
//  GithubFollowersTests
//
//  Created by Kiet Truong on 21/10/2024.
//

import Foundation
import XCTest
import Combine
@testable import GithubFollowers

final class FollowerListVMTests: XCTestCase {
    private var mockUserService: MockUserService!
    private var mockUserRepo: MockUserRepository!
    private var subject: FollowerListVM!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockUserService = MockUserService()
        mockUserRepo = MockUserRepository(userService: mockUserService)
        subject = FollowerListVM(username: "test", userRepository: mockUserRepo)
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockUserService = nil
        mockUserRepo = nil
        subject = nil
    }
    
    func test_fetchFollowers_givenServiceCallSucceeds() {
        // given
        mockUserService.getFetchFollowerListResult = .success(Constants.followers)

        // when
        subject.fetch()
        
        // then
        XCTAssertEqual(mockUserService.getCallsCount, 1)

        subject.$followers
            .sink { XCTAssertEqual($0, Constants.followers) }
            .store(in: &cancellables)
        
        subject.$loadState
            .sink { XCTAssertEqual($0, .loaded) }
            .store(in: &cancellables)
    }
    
    func test_fetchFollowers_givenServiceCallFails() {
        // given
        mockUserService.getFetchFollowerListResult = .failure(APIError.serverError(APIErrorParams(statusCode: 500, message: "Server error")))

        // when
        subject.fetch()
        
        // then
        XCTAssertEqual(mockUserService.getCallsCount, 1)

        subject.$followers
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)
        
        subject.$loadState
            .sink { XCTAssertEqual($0, .error("500 - Server error")) }
            .store(in: &cancellables)
    }
}

extension FollowerListVMTests {
    enum Constants {
        static let followers: [Follower] = [
            Follower(login: "Pope", avatarUrl: "url_1"),
            Follower(login: "Lucas", avatarUrl: "url_2"),
            Follower(login: "Zoe", avatarUrl: "url_3"),
            Follower(login: "Demi", avatarUrl: "url_4"),
            Follower(login: "Oscar", avatarUrl: "url_5")
        ]
    }
}

enum MockError: Error {
    case error
}
