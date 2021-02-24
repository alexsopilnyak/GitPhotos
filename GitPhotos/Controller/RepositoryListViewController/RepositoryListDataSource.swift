//
//  RepositoryListDataSource.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 24.02.2021.
//

import UIKit

class RepositoryListDataSource: NSObject,  UICollectionViewDataSource {
  
  private let cellClass: DefaultCollectionViewCell.Type
  private let collectionView: UICollectionView
  private var repositoryFilesService = ServiceFactory.shared.makeRepositoryFilesService()
  
  private var images = [Image]() {
    didSet {
      collectionView.reloadData()
    }
  }

  init(with collectionView: UICollectionView, displaying cellClass: DefaultCollectionViewCell.Type) {
    self.cellClass = cellClass
    self.collectionView = collectionView
   
    super.init()
    
    self.loadImagesData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdOrClassName, for: indexPath) as? DefaultCollectionViewCell else { fatalError() }
    cell.image = UIImage(data: images[indexPath.row].binaryData)
    cell.title = images[indexPath.row].title
    
    return cell
  }
  
}

extension RepositoryListDataSource {
  func getImages() -> [Image] {
    images
  }
}

private extension RepositoryListDataSource {
  
  func loadImagesData() {
    let group = DispatchGroup()
    guard let accessTokenData = KeyChainService.load(key: Constants.kAccessToken) else { fatalError() }
    guard let accessToken = String(data: accessTokenData, encoding: .utf8) else { fatalError() }
    group.enter()
    repositoryFilesService.getFilesList(with: AccessToken(token: accessToken)) { (files, error) in
      group.leave()
      if error == nil {
        files.forEach {[ weak self ] in
          group.enter()
          self?.repositoryFilesService.getImageData(for: $0) { [ weak self ] (image, error) in
            group.leave()
            if error == nil {
              self?.images.append(image)
            }
          }
        }
        group.notify(queue: .main) {}
      }
    }
  }
  
}
