//
//  AuthCodeRequest.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation

struct AuthCodeRequest: Request {
  
  var url: URL
  var method: RequestMethod
  var parameters: AuthParameters
  var headers: [String : String]?
  
  func create() -> URLRequest? {
    guard let url = makeURLWithParameters() else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
  
}

