//
//  AuthParameters.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation

struct AuthParameters: Encodable {
  
  let clientID: String
  let redirectURI: URL
  let state: String
  let scope: String
  
  private enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case redirectURI = "redirect_uri"
    case state
    case scope
  }
  
}
