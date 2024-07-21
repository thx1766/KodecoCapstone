//
//  Networking.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import Foundation

func loadRecipiesJSON(searchFor: String, timeout: Double) async -> RecipieResults? {
  let baseUrl = Config.apiUrl
  let apiUrlComponent = "/api/recipes/v2?type=public&q="
  let appId = Config.apiAppID
  let appKey = Config.apiAppKey
  let searchString = searchFor.replacingOccurrences(of: " ", with: "%20")
  let urlString = "\(baseUrl)\(apiUrlComponent)\(searchString)&app_id=\(appId)&app_key=\(appKey)"
  if let requestUrl = URL(string: urlString) {
    do {
      let urlsessionconfiguration = URLSessionConfiguration.default
      urlsessionconfiguration.timeoutIntervalForRequest = timeout
      urlsessionconfiguration.timeoutIntervalForResource = timeout
      let urlsession = URLSession(configuration: urlsessionconfiguration)
      let (data, _) = try await urlsession.data(from: requestUrl)
      print("Data: \(data)")
      let decoder = JSONDecoder()
      return try decoder.decode(RecipieResults.self, from: data)
    } catch {
      print("Error loading JSON: \(error)")
      return nil
    }
  } else {
    print("Error loading JSON: Invalid URL")
    return nil
  }
}
