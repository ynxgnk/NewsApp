//
//  APICaller.swift
//  NewsApp
//
//  Created by Nazar Kopeyka on 10.04.2023.
//

import Foundation

final class APICaller { /* 3 */
    static let shared = APICaller() /* 4 */
    
    struct Constants { /* 5 */
        static let topHeadlinesURL = URL(string:
                                            "https://newsapi.org/v2/top-headlines?country=US&apiKey=7be67da124e64c6e957a0a1df0fb8f21") /* 6 */
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=7be67da124e64c6e957a0a1df0fb8f21&q=" /* 135 */
    }
    
    private init() { /* 7 */
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) { /* 8 */ /* 90 change String to Article */
        guard let url = Constants.topHeadlinesURL else { /* 9 */
            return /* 10 */
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in /* 11 */
            if let error = error { /* 12 */
                completion(.failure(error)) /* 13 */
            }
            else if let data = data { /* 14 */
                do { /* 15 */
                    let result = try JSONDecoder().decode(APIResponse.self, from: data) /* 16 */ /* 28 change String.self */
                    
                    print("Articles: \(result.articles.count)") /* 26 */
                    completion(.success(result.articles)) /* 91 */
                }
                catch { /* 17 */
                    completion(.failure(error)) /* 18 */
                }
            }
        }
        
        task.resume() /* 19 */
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) { /* 136 copy from 8 and paste */
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { /* 138 */
            return /* 139 */
        }
        
        let urlString = Constants.searchUrlString + query /* 137 */
        guard let url = URL(string: urlString) else { /* 136 */ /* 140 change COnstants.topHeadlinesURL */
            return /* 136 */
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in /* 136 */
            if let error = error { /* 136 */
                completion(.failure(error)) /* 136 */
            }
            else if let data = data { /* 136 */
                do { /* 136 */
                    let result = try JSONDecoder().decode(APIResponse.self, from: data) /* 136 */
                    
                    print("Articles: \(result.articles.count)") /* 136 */
                    completion(.success(result.articles)) /* 136 */
                }
                catch { /* 136 */
                    completion(.failure(error)) /* 136 */
                }
            }
        }
        
        task.resume() /* 136 */
    }
}

    


//Models

struct APIResponse: Codable { /* 20 */
    let articles: [Article] /* 21 */
}

struct Article: Codable { /* 22 */
    let source: Source /* 23 */
    let title: String /* 23 */
    let description: String? /* 23 */
    let url: String? /* 23 */
    let urlToImage: String? /* 23 */
    let publishedAt: String /* 23 */
}

struct Source: Codable { /* 24 */
    let name: String /* 25 */
}
