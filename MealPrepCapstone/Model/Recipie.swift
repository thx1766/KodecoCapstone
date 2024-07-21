//
//  Recipie.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import Foundation

struct Recipie: Identifiable, Encodable, Decodable {
  var id = UUID()
  var label: String
  var imageUrl: String
  var link: String
  var ingredients: [String]
}
