//
//  RepositoryListViewController.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 24.02.2021.
//

import UIKit

class RepositoryListViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private let repositoryFilesService = ServiceFactory.shared.makeRepositoryFilesService()
  private var dataSource: RepositoryListDataSource?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareCollectionView()
    prepareDataSource()
  }

}

extension RepositoryListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let images = dataSource?.getImages() else { return }
    let image = images[indexPath.row]
    
    if let vc = storyboard?.instantiateViewController(identifier: DetailViewController.reuseIdOrClassName) as? DetailViewController {
      vc.image = image
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension RepositoryListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    return CGSize(width: screenWidth, height: 70)
  }
}

private extension RepositoryListViewController {
  
  func prepareCollectionView() {
    let id = DefaultCollectionViewCell.reuseIdOrClassName
    collectionView.register(UINib(nibName: id, bundle: .main), forCellWithReuseIdentifier: id)
  }
  
  func prepareDataSource() {
    
    dataSource = RepositoryListDataSource(with: collectionView, displaying: DefaultCollectionViewCell.self)
    collectionView.dataSource = dataSource
    collectionView.delegate = self
    collectionView.reloadData()
  }
  
}
