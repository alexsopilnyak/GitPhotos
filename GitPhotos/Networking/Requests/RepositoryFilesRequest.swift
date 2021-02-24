//
//  RepositoryFilesRequest.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 22.02.2021.
//

import Foundation

struct RepositoryFilesRequest: Request {
   
  var url: URL
  var method: RequestMethod
  var parameters: RepositoryParameters
  var headers: [String : String]? {
    return ["Authorization": "token \(parameters.accessToken.token)",
            "Accept": "application/vnd.github.v3+json"]
  }
  

  
  func create() -> URLRequest? {
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
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
