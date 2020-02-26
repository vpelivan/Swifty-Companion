//
//  LoginNetworkService.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 1/28/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation
import AuthenticationServices
import UIKit

class LoginNetworkService {
    static let shared = LoginNetworkService()
    let secretKey = AuthUser.shared.secretKey
    let UID = AuthUser.shared.UID
    let callbackURI = AuthUser.shared.callbackURI
    let intraURL = AuthUser.shared.intraURL
    
    private init() {}
    
    public func refreshToken() {
        let token = AuthUser.shared.token
        let currentStamp = Int(Date().timeIntervalSince1970)
        guard let tokenCreationStamp = token?.createdAt else { return }
        guard let expirationValue = token?.expiresIn else { return }
        guard let bearer = AuthUser.shared.bearer else { return }
        if ((currentStamp - tokenCreationStamp) >= expirationValue) {
            makeRefreshToken(bearer: bearer) {
                print("Token Refreshed")
            }
        }
    }
    
    func makeRefreshToken(bearer: String, completion: @escaping () -> ()) {
        guard let refreshToken = AuthUser.shared.token?.refreshToken else { return }
        let httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secretKey)&\(bearer)&redirect_uri=\(callbackURI)"
        
        guard let url = URL(string: "\(intraURL)oauth/token?grant_type=refresh_token&client_id=&client_secret=&refresh_token=\(refreshToken)") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard error == nil else { return print(error!) }
            do {
                guard let data = data else { return }
                let token = try JSONDecoder().decode(Token.self, from: data)
                AuthUser.shared.token = token
                AuthUser.shared.bearer = bearer
                print(token)
                completion()
            } catch let error {
                print("refresh token error:\n", error)
            }
        }.resume()
    }
    
}
