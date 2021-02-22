//
//  ClientConfig.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import UIKit

enum APIData {
  
  static let authURL =  URL(string: "https://github.com/login/oauth/authorize")!
  static let tokenURL = URL(string: "https://github.com/login/oauth/access_token")!
  static let redirectURI = URL(string: "com.alexsopilnyak.GitPhotos://authentication")!
 
  static let clientID = "d6dee4aff252bbb87ce3"
  static let clientSecret = "f0915c95790cce3f17a75af0752d72d05217b595"
  
  static let scope = "repo:user"
  
  
}
