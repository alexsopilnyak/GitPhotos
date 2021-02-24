//
//  UserTokenRequest.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation
struct TokenRequest: Request {
  var url: URL
  var method: RequestMethod
  var parameters: TokenParameters
  var headers: [String : String]? {
    return ["Accept":"application/json"]
  }
  
  func create() -> URLRequest? {
    guard let url = makeURLWithParameters() else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    setHeadersIn(&request)
    return request
  }
  
  private func setHeadersIn(_ request: inout URLRequest) {
    guard let headers = headers else { return }
    for (key, value) in headers {
      request.addValue(value, forHTTPHeaderField: key)
    }
  }
  
}

