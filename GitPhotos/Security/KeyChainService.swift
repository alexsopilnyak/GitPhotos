//
//  KeyChainService.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 23.02.2021.
//

import Foundation
// https://stackoverflow.com/questions/30719638/save-and-retrieve-value-via-keychain

class KeyChainService {
  
  class func save(key: String, data: Data) -> OSStatus {
    let query = [
      kSecClass as String       : kSecClassGenericPassword as String,
      kSecAttrAccount as String : key,
      kSecValueData as String   : data ] as [String : Any]
    
    SecItemDelete(query as CFDictionary)
    
    return SecItemAdd(query as CFDictionary, nil)
  }
  
  class func load(key: String) -> Data? {
    let query = [
      kSecClass as String       : kSecClassGenericPassword,
      kSecAttrAccount as String : key,
      kSecReturnData as String  : kCFBooleanTrue!,
      kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
    
    var dataTypeRef: AnyObject? = nil
    
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == noErr {
      return dataTypeRef as! Data?
    } else {
      return nil
    }
  }
  
  class func createUniqueID() -> String {
    let uuid: CFUUID = CFUUIDCreate(nil)
    let cfStr: CFString = CFUUIDCreateString(nil, uuid)
    
    let swiftString: String = cfStr as String
    return swiftString
  }
}

extension Data {
  
  //https://stackoverflow.com/questions/60857760/warning-initialization-of-unsafebufferpointert-results-in-a-dangling-buffer
  
  init<T>(from value: T) {
    var value = value
    var myData = Data()
    withUnsafePointer(to:&value, { (ptr: UnsafePointer<T>) -> Void in
      myData = Data( buffer: UnsafeBufferPointer(start: ptr, count: 1))
    })
    self.init(myData)
  }
}
