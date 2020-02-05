//
//  NetworkService.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 11/6/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    public func getData<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (Any) -> ()) {
        guard let token = AuthUser.shared.token?.accessToken else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                guard let data = data else { return }
                let Data = try JSONDecoder().decode(type.self, from: data)
                completion(Data)
            }
            catch let error {
                return print(error)
            }
        }.resume()
    }
    
    public func getImage(from url: URL, completion: @escaping (UIImage) -> ()) {
        let session = URLSession.shared
        session.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }.resume()
    }
}
