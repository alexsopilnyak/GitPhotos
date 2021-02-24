//
//  UIResponder.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 24.02.2021.
//

import UIKit

extension UIResponder {
  class var reuseIdOrClassName: String {
    String(describing: self)
  }
}
