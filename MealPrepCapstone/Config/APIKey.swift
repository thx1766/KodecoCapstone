//
//  APIKey.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import Foundation

enum Config {
  static var apiAppID: String {
    return getValue(forKey: "API_APP_ID")
  }

  static var apiAppKey: String {
    return getValue(forKey: "API_APP_KEY")
  }

  static var apiUrl: String {
    return getValue(forKey: "API_URL")
  }

  private static func getValue(forKey key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
      fatalError("Couldn't find file 'APIKey.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: key) as? String else {
      fatalError("Couldn't find key '\(key)' in 'APIKey.plist'.")
    }
    return value
  }
}
