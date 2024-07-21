//
//  SavedRecipieToolbarButtonView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SavedRecipieToolbarButtonView: View {
  @ObservedObject var dataStore: DataStore
  @State var recipie: Recipie
  var body: some View {
    Button(action: {
      print("Delete Recipe")
      dataStore.recipies.removeAll { $0.id == recipie.id }
      do {
        let encodedData = try JSONEncoder().encode(dataStore.recipies)
        UserDefaults.standard.set(encodedData, forKey: "savedRecipies")
        dataStore.deleteFileFromSavedImages(label: recipie.label)
      } catch {
        print("Error saving data")
      }
    }, label: {
      HStack {
        Text("Delete Recipie").foregroundStyle(.red)
        Image(systemName: "trash.fill").foregroundStyle(.red)
      }
    })
  }
}

#Preview {
  @ObservedObject var dataStore = DataStore()
  @State var recipie = Recipie(
    label: "label",
    imageUrl: "image",
    link: "url",
    ingredients: ["ingredient1", "ingredient2"]
  )
  return VStack {
    SavedRecipieToolbarButtonView(dataStore: dataStore, recipie: recipie)
  }
}
