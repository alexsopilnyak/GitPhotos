//
//  AuthService.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

protocol AuthService {
  func getAuthCode(from url: URL) -> String?
  func getAccessToken(from authCode: String, completion: @escaping (AccessToken, Error?) ->())
}


class DefaultAuthService {
  typealias NetworkService = NetworkServiceForSingleResponse & NetworkServiceForMultipleResponse
  typealias Code = String
  
  private let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
}


extension DefaultAuthService: AuthService {
  func getAuthCode(from url: URL) -> Code? {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
    
    if let code = code {
        return code
    } else {
        return nil
    }
  }
  
  func getAccessToken(from authCode: Code, completion: @escaping (AccessToken, Error?) -> ()) {
    guard let safeRedirectURI = APIData.redirectURI else { return }
    let tokenParams = TokenParameters(clientID: APIData.clientID,
                                      clientSecret: APIData.clientSecret,
                                      redirectURI: safeRedirectURI,
                                      state: APIData.userState,
                                      code: authCode,
                                      grantType: APIData.grantType)
    guard let safeTokenURL = APIData.tokenURL else { return }
    guard let tokenRequest = TokenRequest(url: safeTokenURL, method: .post, parameters: tokenParams).create() else {
      return
    }
    
    networkService.perform(request: tokenRequest) { (request: AccessToken?, error) in
      if let token = request {
        DispatchQueue.main.async {
          completion(token, error)
        }
      }
    }
  }
  
  
}
