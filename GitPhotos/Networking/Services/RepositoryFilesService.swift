//
//  RepositoryFilesService.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

protocol RepositoryFilesService {
  func getFilesList(with token: AccessToken, completion: @escaping ([File], Error?) -> ())
  func getImageData(for file: File, completion: @escaping (Image, Error?) -> ())
}


class DefaultRepositoryFilesService {
  typealias NetworkService = NetworkServiceForSingleResponse & NetworkServiceForMultipleResponse
  
  private let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
}

extension DefaultRepositoryFilesService: RepositoryFilesService {
  func getFilesList(with token: AccessToken, completion: @escaping ([File], Error?) -> ()) {

    let repositoryParams = RepositoryParameters(accessToken: token)
    guard let safeRepoURL = APIData.repositoryURL else { return }
    guard let repoFilesRequest = RepositoryFilesRequest(url: safeRepoURL, method: .get, parameters: repositoryParams).create() else
    { return }
    
    networkService.perform(request: repoFilesRequest) { (response: [File]?, error) in
      if let files = response {
        DispatchQueue.main.async {
          completion(files, error)
        }
      }
    }
  }
  
  func getImageData(for file: File, completion: @escaping (Image, Error?) -> ()) {
    guard let downloadURL = URL(string: file.downloadURL) else { return }
    networkService.loadImageData(url: downloadURL) { (data: Data?, error) in
      if let binaryData = data {
        let image = Image(title: file.name, sha: file.sha, binaryData: binaryData)
        
        DispatchQueue.main.async {
          completion(image, error)
        }
      }
    }
  }
  
  
}
