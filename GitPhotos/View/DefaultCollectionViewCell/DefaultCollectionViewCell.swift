//
//  DefaultCollectionViewCell.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import UIKit

protocol ImageContaining {

  var image: UIImage? { get set }
  var title: String? { get set }

}

class DefaultCollectionViewCell: UICollectionViewCell, ImageContaining {
 
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func prepareForReuse() {
    image = nil
    title = nil
  }

}
