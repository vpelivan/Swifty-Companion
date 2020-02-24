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
    
    public func getData<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (Any, Result<String, Error>) -> ()) {
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
//                let json: NSDictionary = try (JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary)!
//                print(json)
                completion(Data, .success("API Data successfuly transfered"))
            }
            catch let error {
                OtherMethods.shared.alert(title: "Server Request Error", message: "For some reasons an application did not manage to get data from server. Try again later")
                completion(error, .failure(error))
            }
        }.resume()
    }
    
    public func getDataWithoutAlarm<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (Any, Result<String, Error>) -> ()) {
            guard let token = AuthUser.shared.token?.accessToken else { return }
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 2
            configuration.timeoutIntervalForResource = 2
            session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do
                {
                    guard let data = data else { return }
                    let Data = try JSONDecoder().decode(type.self, from: data)

                    completion(Data, .success("API Data successfuly transfered"))
                }
                catch let error {
                    completion(error, .failure(error))
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
    
    public func errorHandler(to handle: Result<String, Error>, completion: ()->()) {
        switch handle {
        case .success(let string):
            print(string)
            completion()
        case .failure(let error):
            print("Failed to load data: ", error)
            return
        }
    }
}
