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
    
    public func getData(url: URL, completion: @escaping (Any) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }
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
