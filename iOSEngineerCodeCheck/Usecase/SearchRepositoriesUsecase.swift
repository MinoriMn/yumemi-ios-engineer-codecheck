//
//  SearchRepositoriesUsecase.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine

final class SearchRepositoriesUsecase {
    private let githubRepository = GithubRepository()

    private var searchedRepositories: [Repository] = []

    public func searchRepogitories(searchWord: String) -> AnyPublisher<[Repository], Error> {
        githubRepository.searchRepogitories(searchWord: searchWord)
            .flatMap { [weak self] repositories -> AnyPublisher<[Repository], Error> in
                guard let self = self else { return Fail(error: UsecaseError.couldNotFoundSelf).eraseToAnyPublisher() }
                guard !repositories.isEmpty else { return Fail(error: UsecaseError.noRepositories).eraseToAnyPublisher() }

                self.searchedRepositories = repositories

                return Just(repositories).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func getRepository(index: Int) -> AnyPublisher<Repository, Error> {
        return Just(searchedRepositories[safe: index])
            .setFailureType(to: Error.self)
            .flatMap { repository -> AnyPublisher<Repository, Error> in
                guard let repository = repository else { return Fail(error: UsecaseError.notExistIndex).eraseToAnyPublisher() }
                return Just(repository).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension SearchRepositoriesUsecase {
    public enum UsecaseError: Error {
        case noRepositories
        case couldNotFoundSelf
        case notExistIndex
    }
}
