//
//  ServicesFactory.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

class ServiceFactory {
  typealias NetworkService = NetworkServiceForSingleResponse & NetworkServiceForMultipleResponse
  
  static var shared = ServiceFactory()
  
  func makeAuthService() -> AuthService {
    return DefaultAuthService(networkService: makeNetworkService())
  }
  
  func makeRepositoryFilesService() -> RepositoryFilesService {
    return DefaultRepositoryFilesService(networkService: makeNetworkService())
  }
  
  private func makeNetworkService() -> NetworkService {
    return DefaultNetworkService()
  }
}
