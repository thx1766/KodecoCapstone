//
//  SavedRecipieDetailView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SavedRecipieDetailView: View {
  @State var recipie: Recipie
  @Binding var imageData: UIImage?
  @ObservedObject var dataStore: DataStore
  @State var urlError = false

  var body: some View {
    if dataStore.recipies.contains(where: { $0.link == recipie.link }) {
      VStack {
        Text("\(recipie.label)")
        if let imageData = imageData {
          Image(uiImage: imageData)
        } else {
          Image(systemName: "exclamationmark.triangle")
        }
        Button(action: {
          if let url = URL(string: recipie.link) {
            UIApplication.shared.open(url)
          } else {
            urlError = true
          }
        }, label: {
          Text("Open Recipe in Browser")
        })
        Text("Ingredients:")
        List {
          ForEach(recipie.ingredients, id: \.self) { ingredient in
            Text(ingredient)
          }
        }
      }
      .sheet(isPresented: $urlError) {
        Text("Error opening link")
        Button("Dismiss") {
          urlError = false
        }
      }
    } else {
      EmptyView()
    }
  }
}

#Preview {
  @ObservedObject var dataStore = DataStore()
  var recipieVar: Recipie
  var imageDataVar: UIImage?

  if dataStore.recipies.isEmpty {
    recipieVar = dataStore.recipies[0]
    let fileManager = FileManager.default
    let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    if let directory = directories.first {
      let fileURL = directory.appendingPathComponent(recipieVar.label)
      imageDataVar = UIImage(contentsOfFile: fileURL.path)
    } else {
      imageDataVar = UIImage(systemName: "exclamationmark.triangle")
    }
  } else {
    recipieVar = Recipie(
      label: "No Saved Recipies",
      imageUrl: "no image",
      link: "no link",
      ingredients: ["no ingredients"]
    )
    imageDataVar = UIImage(systemName: "photo")
  }
  @State var recipie = recipieVar
  @State var imageData = imageDataVar
  return VStack {
    Text("datastoure recipie count: \(dataStore.recipies.count)")
    SavedRecipieDetailView(recipie: recipie, imageData: $imageData, dataStore: dataStore)
  }
}
