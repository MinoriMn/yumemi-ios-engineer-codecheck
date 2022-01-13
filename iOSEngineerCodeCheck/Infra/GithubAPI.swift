//
//  GithubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

final class GithubAPI {
    public func searchRepogitories(searchWord: String) -> AnyPublisher<[Repository], Error> {
        guard !searchWord.isEmpty else { return Fail(error: APIError.emptySearchWord).eraseToAnyPublisher() }

        return Future<[Repository], Error>() { promise in
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else {
                promise(.failure(APIError.couldNotGenerateRequestURL))
                return
            }

            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let err = err {
                    promise(.failure(err))
                    return
                }

                guard let data = data,
                      let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = obj["items"] as? [[String: Any]] else {
                          promise(.failure(APIError.couldNotGenerateJsonItems))
                          return
                      }

                var repositories: [Repository] = []

                for item in items {
                    var avaterUrl: URL? = nil
                    if let ownerItem = item["owner"] as? [String: Any],
                       let imgURLString = ownerItem["avatar_url"] as? String,
                       let imgUrl = URL(string: imgURLString) {
                        avaterUrl = imgUrl
                    }

                    repositories.append(.init(
                        fullName: item["full_name"] as? String,
                        language: item["language"] as? String,
                        stargazersCount: item["stargazers_count"] as? Int,
                        wachersCount: item["wachers_count"] as? Int,
                        forksCount: item["forks_count"] as? Int,
                        openIssuesCount: item["open_issues_count"] as? Int,
                        owner: .init(avaterUrl: avaterUrl)
                    ))
                }

                promise(.success(repositories))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension GithubAPI {
    public enum APIError: Error {
        case emptySearchWord
        case couldNotGenerateRequestURL
        case couldNotGenerateJsonItems
    }
}
