//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var stargazersLabel: UILabel!
    @IBOutlet private weak var wachersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!
    
    var rootViewController: RootViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelsText()
        getImage()
    }

    private func setLabelsText() {
        guard let repository = rootViewController.repositories[safe: rootViewController.selectedRepogitoryIndex] else { return }

        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        stargazersLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        wachersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }
    
    private func getImage(){
        guard let repository = rootViewController.repositories[safe: rootViewController.selectedRepogitoryIndex] else { return }
        
        titleLabel.text = repository["full_name"] as? String

        guard let owner = repository["owner"] as? [String: Any],
              let imgURL = owner["avatar_url"] as? String,
              let url = URL(string: imgURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data,
                  let img = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
    }
}
