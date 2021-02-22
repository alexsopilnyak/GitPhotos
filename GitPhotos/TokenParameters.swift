//
//  TokenParameters.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation

struct TokenParameters: Encodable {
  let clientID: String
  let clientSecret: String
  let redirectURI: URL
  let state: String
  let code: String
  
  private enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case redirectURI = "redirect_uri"
    case state
    case code
  }
}


struct Token: Decodable {
  let accessToken: String
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }
}
