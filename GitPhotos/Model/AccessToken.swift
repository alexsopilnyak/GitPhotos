//
//  AccessToken.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

struct AccessToken: Codable {
  let token: String
  
  private enum CodingKeys: String, CodingKey {
    case token = "access_token"
  }
}
