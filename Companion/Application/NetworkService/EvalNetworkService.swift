//
//  EvalNetworkService.swift
//  SwiftyCompanion
//
//  Created by Victor Pelivan on 2/24/20.
//  Copyright © 2020 Viktor PELIVAN. All rights reserved.
//

import Foundation

class EvalNetworkSevice {
    static let shared = EvalNetworkSevice()
    private init() {}
    
    public func skipEvaluation(with scaleTeamsID: Int, completion: @escaping ()->()) {
        let intraURL = AuthUser.shared.intraURL
        guard let token = AuthUser.shared.token?.accessToken else { return }
        let url = URL(string: "\(intraURL)/v2/scale_teams/\(scaleTeamsID)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request  as URLRequest)
        {
            (data, response, error) in
            if let error = error {
                print("optional error binding: ", error)
                return
            }
            do {
                if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                    print("Dictionary content: ", dictionary)
                    if (dictionary["error"] == nil) {
                        print("if in do: Skip Failed")
                        completion()
                    }
                    else {
                        print("else in do: Skip Failed", dictionary)
                    }
                }
                else {
                    print("Skip Failed")
                }
            }
            catch {
                completion()
                print("Catch Block: Skip Succeded")
            }
        }.resume()
    }
}
