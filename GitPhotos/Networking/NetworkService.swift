//
//  NetworkService.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import Foundation

protocol NetworkService {
  func perform<Response: Codable, T: Request>(request: T, completion: (Response?, Error?) -> ())
}
