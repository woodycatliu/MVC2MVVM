//
//  DataModel.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/14.
//

import UIKit

protocol Response {
    associatedtype  DecodeType: Codable
    var value: DecodeType? { get set }
}
struct HttpResult<T: Codable>: Response {
    var value: T?
}

protocol Reqs {
    associatedtype T: Codable
    var request: URLRequest? { get set }
}

struct Request<T: Codable>: Reqs {
    typealias Response = T
    var request: URLRequest?
}

struct DataModel: Codable {
    var item: String?
    var description: String?
    var imageUrl: String?
    var price: Double?
    var baseUrl: String?
    var crateOn: Double?
}

