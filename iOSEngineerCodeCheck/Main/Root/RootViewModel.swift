//
//  RootViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine

class RootViewModel {
    private let usecase: SearchRepositoriesUsecase

    init(usecase: SearchRepositoriesUsecase) {
        self.usecase = usecase
    }

    func transform(input: Input) -> Output {
        let searchResult = input.searchBarSearchButtonClicked
            .flatMap { [weak self] searchWord -> AnyPublisher<[Repository], Error> in
                guard let self = self else { return Fail(error: CommonError.couldNotFoundSelf).eraseToAnyPublisher() }
                return self.usecase.searchRepogitories(searchWord: searchWord)
            }
            .eraseToAnyPublisher()

        return .init(searchResult: searchResult)
    }
}

extension RootViewModel {
    struct Input {
        let searchBarSearchButtonClicked: AnyPublisher<String, Error>
    }

    struct Output {
        let searchResult: AnyPublisher<[Repository], Error>
    }
}
