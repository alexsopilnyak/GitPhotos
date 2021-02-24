//
//  DetailViewController.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 24.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  
  var image: Image!  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let binaryData = image?.binaryData else { fatalError() }
    imageView.image = UIImage(data: binaryData)
    
    navigationItem.title = image?.title

  }
 
}
