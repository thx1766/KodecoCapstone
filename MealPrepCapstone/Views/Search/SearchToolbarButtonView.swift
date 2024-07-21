//
//  SearchToolbarButtonView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SearchToolbarButtonView: View {
  @ObservedObject var dataStore: DataStore
  @State var hit: RecipieResult
  var body: some View {
    Button(action: {
      print("Save Recipe")
      let link = hit.recipe.url
      if dataStore.recipies.contains(where: { $0.link == link }) {
        withAnimation {
          dataStore.recipies.removeAll { $0.link == link }
        }
      } else {
        let label = hit.recipe.label
        let image = hit.recipe.image
        let ingredients = hit.recipe.ingredientLines
        let newRecipie = Recipie(label: label, imageUrl: image, link: link, ingredients: ingredients)
        withAnimation {
          dataStore.loadingData = true
          dataStore.recipies.append(newRecipie)
          do {
            UserDefaults.standard.set(try JSONEncoder().encode(dataStore.recipies), forKey: "savedRecipies")
          } catch {
            print("Error saving data")
          }
          Task {
            await dataStore.addFileToSavedImages(image: image, label: label)
          }
        }
      }
    }, label: {
      if dataStore.recipies.contains(where: { $0.link == hit.recipe.url }) {
        HStack {
          Text("Delete")
          Image(systemName: "trash.fill")
        }.transition(.move(edge: .leading))
          .foregroundStyle(.red)
      } else {
        HStack {
          Text("Save")
          Image(systemName: "bookmark")
        }.transition(.move(edge: .trailing))
          .foregroundStyle(.blue)
      }
    })
  }
}

#Preview {
  @ObservedObject var dataStore = DataStore()
  let recipie = RecipieJSON(
    label: "label",
    image: "image",
    url: "url",
    ingredientLines: ["ingredient1", "ingredient2"]
  )
  @State var hit = RecipieResult(recipe: recipie)
  return VStack {
    SearchToolbarButtonView(dataStore: dataStore, hit: hit)
  }
}
