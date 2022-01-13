//
//  GithubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine

final class GithubRepository {
    private let githubAPI = GithubAPI()

    public func searchRepogitories(searchWord: String) -> AnyPublisher<[Repository], Error> {
        githubAPI.searchRepogitories(searchWord: searchWord)
    }
}
