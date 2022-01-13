//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class RootViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var repositories: [Repository] = []

    private var viewModel: RootViewModel?
    private var input: Input?
    private var cancellables = [AnyCancellable]()

    private let searchBarSearchButtonClickedPublisher = PassthroughSubject<String, Error>()

    private var selectedRepository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self

        bindInput(input: .init(usecase: .init()))
    }

    private func bindInput(input: Input) {
        self.input = input
        self.viewModel = .init(usecase: input.usecase)

        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let output = viewModel.transform(
            input: .init(
                searchBarSearchButtonClicked: searchBarSearchButtonClickedPublisher.eraseToAnyPublisher()
            ))

        output.searchResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    // TODO: エラー表示
                    print(error)
                }
            }, receiveValue: { [weak self] repositories in
                // 検索結果更新
                self?.repositories = repositories
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 検索バーの値の初期化
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text,
              searchBarText.count != 0 else { return }

        // 検索の実行
        searchBarSearchButtonClickedPublisher.send(searchBarText)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Detail",
              let detailViewController = segue.destination as? DetailViewController,
              let selectedRepository = selectedRepository,
              let input = input else { return }

        detailViewController.bindInput(input: .init(
            selectedRepository: selectedRepository,
            usecase: input.usecase)
        )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        if let repository = repositories[safe: indexPath.row] {
            cell.textLabel?.text = repository.fullName
            cell.detailTextLabel?.text = repository.language
        }

        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面に遷移
        selectedRepository = repositories[safe: indexPath.row]
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension RootViewController {
    public struct Input {
        let usecase: SearchRepositoriesUsecase
    }
}
