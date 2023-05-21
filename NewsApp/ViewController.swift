//
//  ViewController.swift
//  NewsApp
//
//  Created by Nazar Kopeyka on 10.04.2023.
//

import UIKit
import SafariServices /* 128 import */

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate { /* 37 add 2 protocols */ /* 146 add SearchBarDelegate */

    private let tableView: UITableView = { /* 33 */
        let table = UITableView() /* 34 */
        table.register(NewsTableViewCell.self, /* 101 change UITableViewCell */
                       forCellReuseIdentifier: NewsTableViewCell.identifier) /* 35 */ /* 102 change "cell" */
        return table /* 36 */
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil) /* 143 */
    
    private var viewModels = [NewsTableViewCellViewModel]() /* 89 */
    private var articles = [Article]() /* 125 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News" /* 1 */
        view.addSubview(tableView) /* 98 */
        tableView.delegate = self /* 99 */
        tableView.dataSource = self /* 100 */
        view.backgroundColor = .systemBackground /* 2 */
        
        fetchTopStories() /* 134 */
        createSearchBar() /* 142 */
    }
    
    override func viewDidLayoutSubviews() { /* 46 */
        super.viewDidLayoutSubviews() /* 47 */
        tableView.frame = view.bounds /* 48 */
    }
    
    private func createSearchBar() { /* 141 */
        navigationItem.searchController = searchVC /* 144 */
        searchVC.searchBar.delegate = self /* 145 allows us to get events when the user taps on the search button */
    }
    
    private func fetchTopStories() { /* 133 */
        APICaller.shared.getTopStories { [weak self] result in /* 27 */ /* 92 add weka self */
            switch result { /* 29 */
            case .success(let articles): /* 30 */
//                break /* 31 */
                self?.articles = articles /* 124 */
                self?.viewModels = articles.compactMap({ /* 93 */
                    NewsTableViewCellViewModel( /* 94 */
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async { /* 95 */
                    self?.tableView.reloadData() /* 96 */
                }
            case .failure(let error): /* 30 */
                print(error) /* 32 */
            }
        }
    }

    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 38 */
        return viewModels.count /* 39 */ /* 97 change 0 */
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 40 */
        guard let cell = tableView.dequeueReusableCell( /* 87 add guard */
            withIdentifier: NewsTableViewCell.identifier, /* 84 change "cell" */
        for: indexPath
        ) as? NewsTableViewCell else { /* 41 */ /* 85 add as */
            fatalError() /* 86 */
        }
//        cell.textLabel?.text = "Something" /* 42 */
        cell.configure(with: viewModels[indexPath.row]) /* 88 */
        return cell /* 43 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 44 */
        tableView.deselectRow(at: indexPath, animated: true) /* 45 */
        let article = articles[indexPath.row] /* 123 */
        
        guard let url = URL(string: article.url ?? "") else { /* 126 */
            return /* 127 */
        }
        
        let vc = SFSafariViewController(url: url) /* 129 */
        present(vc, animated: true) /* 130 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 104 */
        return 150 /* 105 */
    }
    
    //Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { /* 147 */
        guard let text = searchBar.text, !text.isEmpty else { /* 148 */
            return /* 149 */
        }
        
        APICaller.shared.search(with: text) { [weak self] result in /* 151 copy from 27 */
            switch result { /* 151 */
            case .success(let articles): /* 151 */
                self?.articles = articles /* 151 */
                self?.viewModels = articles.compactMap({ /* 151 */
                    NewsTableViewCellViewModel( /* 151 */
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async { /* 151 */
                    self?.tableView.reloadData() /* 151 */
                    self?.searchVC.dismiss(animated: true, completion: nil) /* 152 */
                }
            case .failure(let error): /* 151 */
                print(error) /* 151 */
            }
        }
//        print(text) /* 150 */
    }
}

