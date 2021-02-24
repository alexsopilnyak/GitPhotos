//
//  File.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation

struct File: Codable {
  var name: String
  var sha: String
  var downloadURL: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case sha
    case downloadURL = "download_url"
  }
}
