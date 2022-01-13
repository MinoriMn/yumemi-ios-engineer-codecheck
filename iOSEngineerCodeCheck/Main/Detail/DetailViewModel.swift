//
//  DetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class DetailViewModel {
    private let repository: Repository
    private let usecase: SearchRepositoriesUsecase

    init(repository: Repository, usecase: SearchRepositoriesUsecase) {
        self.repository = repository
        self.usecase = usecase
    }

    func transform(input: Input) -> Output {
        let repositoryPublisher = Just(repository).setFailureType(to: Error.self).eraseToAnyPublisher()
        let avaterImagePublisher = usecase.getAvaterImage(repository: repository)

        return .init(
            repository: repositoryPublisher,
            avaterImage: avaterImagePublisher
        )
    }
}

extension DetailViewModel {
    struct Input {
    }

    struct Output {
        let repository: AnyPublisher<Repository, Error>
        let avaterImage: AnyPublisher<UIImage?, Error>
    }
}

