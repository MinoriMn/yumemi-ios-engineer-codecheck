//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public struct Repository: Codable, Hashable {
    public let fullName: String?
    public let language: String?
    public let stargazersCount: Int?
    public let wachersCount: Int?
    public let forksCount: Int?
    public let openIssuesCount: Int?
    public let owner: Owner

    public init(fullName: String?, language: String?, stargazersCount: Int?, wachersCount: Int?, forksCount: Int?, openIssuesCount: Int?, owner: Owner) {
        self.fullName = fullName
        self.language = language
        self.stargazersCount = stargazersCount
        self.wachersCount = wachersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.owner = owner
    }
}

public struct Owner: Codable, Hashable {
    public let avatarUrl: URL?

    public init(avaterUrl: URL?) {
        self.avatarUrl = avaterUrl
    }
}
