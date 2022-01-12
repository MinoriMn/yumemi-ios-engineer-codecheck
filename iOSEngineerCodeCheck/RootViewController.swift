//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private(set) var repositories: [[String: Any]]=[]

    private var searchWord: String = ""
    private var searchRepositoriesUrl: String = ""
    private var searchRepositoriesTask: URLSessionTask?
    private(set) var selectedRepogitoryIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 検索バーの値の初期化
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRepositoriesTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text,
              searchBarText.count != 0 else { return }

        searchWord = searchBarText
        searchRepositoriesUrl = "https://api.github.com/search/repositories?q=\(searchWord)"

        guard let url = URL(string: searchRepositoriesUrl) else { return }

        searchRepositoriesTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data,
                  let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let items = obj["items"] as? [[String: Any]] else { return }

            self.repositories = items
            DispatchQueue.main.async {
                // 検索結果更新
                self.tableView.reloadData()
            }
        }
        // 検索の実行
        searchRepositoriesTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Detail",
              let dtl = segue.destination as? DetailViewController else { return }

        dtl.rootViewController = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if let repository = repositories[safe: indexPath.row] {
            cell.textLabel?.text = repository["full_name"] as? String ?? ""
            cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        }

        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面に遷移
        selectedRepogitoryIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
