//
//  APIEngine.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/14.
//

import Foundation
import UIKit

enum APIError: Error { case error }
class APIEngine {
    static let shared: APIEngine = .init()
    private init() {}
    
    func fetchFoo<Req: Reqs>(req: Req, completion: @escaping (Swift.Result<HttpResult<Req.T>, APIError>)-> ()) {
        let data = Data()
        completion(.success(.init(value: try? JSONDecoder().decode(Req.T.self, from: data))))
    }
    
    func fetchImg(urlString: String, defaultImg: UIImage?, completion: @escaping (UIImage?)-> ()) {
        // after fetch
        let img: UIImage? = defaultImg
        completion(img)
    }
}
