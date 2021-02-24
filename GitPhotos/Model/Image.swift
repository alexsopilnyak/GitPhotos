//
//  Image.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

struct Image: Codable {
  let title: String
  let sha: String
  let binaryData: Data
}
