//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var stargazersLabel: UILabel!
    @IBOutlet private weak var wachersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!

    private var viewModel: DetailViewModel?
    private var input: Input?
    private var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func bindInput(input: Input) {
        self.input = input
        self.viewModel = .init(
            repository: input.selectedRepository,
            usecase: input.usecase
        )

        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let output = viewModel.transform(input: .init())

        output.repository
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    // TODO: エラー表示
                    print(error)
                }
            }, receiveValue: { [weak self] repository in
                self?.setLabelsText(repository: repository)
            })
            .store(in: &cancellables)

        output.avaterImage
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    // TODO: エラー表示
                    print(error)
                }
            }, receiveValue: { [weak self] image in
                guard let image = image ?? UIImage(named:"noImage") else { return }
                self?.setImage(image: image)
            })
            .store(in: &cancellables)
    }

    private func setLabelsText(repository: Repository) {
        titleLabel.text = repository.fullName
        languageLabel.text = "Written in \(repository.language ?? "")"
        stargazersLabel.text = "\(repository.stargazersCount ?? 0) stars"
        wachersLabel.text = "\(repository.wachersCount ?? 0) watchers"
        forksLabel.text = "\(repository.forksCount ?? 0) forks"
        issuesLabel.text = "\(repository.openIssuesCount ?? 0) open issues"
    }
    
    private func setImage(image: UIImage) {
        imageView.image = image
    }
}

extension DetailViewController {
    public struct Input {
        let selectedRepository: Repository
        let usecase: SearchRepositoriesUsecase
    }
}
