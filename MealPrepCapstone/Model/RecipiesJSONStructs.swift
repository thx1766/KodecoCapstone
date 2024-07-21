//
//  RecipiesJSONStructs.swift
//  MealPrep
//
//  Created by Nate Schaffner on 7/6/24.
//

import Foundation

struct RecipieResults: Decodable, Identifiable {
  let id = UUID()
  let hits: [RecipieResult]?
  enum CodingKeys: String, CodingKey {
    case  hits
  }
}

struct RecipieResult: Decodable, Identifiable {
  let id = UUID()
  let recipe: RecipieJSON
  enum CodingKeys: String, CodingKey {
    case recipe
  }
}

struct RecipieJSON: Decodable {
  let id = UUID()
  let label: String
  let image: String
  let url: String
  let ingredientLines: [String]
  // let ingredients: [Ingredient]
  enum CodingKeys: String, CodingKey {
    case label, image, url, ingredientLines// , ingredients
  }
}

// struct Ingredient: Decodable {
//  let text: String
//  let quantity: Double
//  let measure: String?
//  let food: String
//  let weight: Double
// }
