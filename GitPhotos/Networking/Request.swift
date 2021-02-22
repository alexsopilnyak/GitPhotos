//
//  Request.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation
protocol Request {
  associatedtype Parameters: Encodable
  var url: URL { get }
  var method: RequestMethod { get }
  var parameters: Parameters { get }
  var headers: [String: String]? { get }
  
  func create() -> URLRequest?
  
}

extension Request {
  func makeURLWithParameters() -> URL? {
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    let queryItems = try? parameters.asDictionary().map { URLQueryItem(name: $0, value: "\($1)") }
    components?.queryItems = queryItems
    return components?.url
  }
}

enum RequestMethod: String {
  case get = "GET"
  case post = "POST"
}
