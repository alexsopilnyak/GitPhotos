//
//  NetworkService.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import UIKit

protocol NetworkServiceForSingleResponse {
  func perform<Response: Codable>(request: URLRequest, completion: @escaping (Response?, Error?) -> ())
  func loadImageData(url: URL, completion: @escaping (Data?, Error?) -> ())
}

protocol NetworkServiceForMultipleResponse {
  func perform<Response: Codable>(request: URLRequest, completion: @escaping ([Response]?, Error?) -> ())
}


class DefaultNetworkService {}

extension DefaultNetworkService: NetworkServiceForSingleResponse {
  func perform<Response: Codable>(request: URLRequest, completion: @escaping (Response?, Error?) -> ()) {
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        completion(nil, error)
        return
      }
      
      do {
        let result = try JSONDecoder().decode(Response.self, from: data)
        completion(result, error)
      } catch {
        completion(nil, error)
      }
      
    }.resume()
  }
  
  func loadImageData(url: URL, completion: @escaping (Data?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        completion(nil, error)
        return
      }
      
      completion(data, error)
      
    }.resume()
  }
}

extension DefaultNetworkService: NetworkServiceForMultipleResponse {
  func perform<Response: Codable>(request: URLRequest, completion: @escaping ([Response]?, Error?) -> ()) {
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        completion(nil, error)
        return
      }
      
      do {
        let result = try JSONDecoder().decode([Response].self, from: data)
        completion(result, error)
      } catch {
        completion(nil, error)
      }
      
    }.resume()
  }
}
