//
//  SearchNetworkService.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 2/13/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation

class SearchNetworkService {
    static let shared = SearchNetworkService()
        private init() {}
        
        public func getSearchData(from url: URL, completion: @escaping ([UserSearch?]) -> ()) {
            guard let token = AuthUser.shared.token?.accessToken else { return }

            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1
            session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do
                {
                    guard let data = data else { return }
                    let Data = try JSONDecoder().decode([UserSearch?].self, from: data)
                    completion(Data)
                }
                catch let error {
                    print(error)
                }
            }.resume()
        }
    
    
}
