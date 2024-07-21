//
//  SavedRecipiesView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SavedRecipiesView: View {
  @ObservedObject var dataStore: DataStore
  @State var savedRecipieSearchText = ""
  @State var imageData: UIImage?

  var filteredRecipies: [Recipie] {
    if savedRecipieSearchText.isEmpty {
      return dataStore.recipies
    } else {
      return dataStore.recipies.filter { $0.label.contains(savedRecipieSearchText) }
    }
  }
  func loadImageData(recipie: Recipie) {
    let fileManager = FileManager.default
    let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    if let directory = directories.first {
      let fileURL = directory.appendingPathComponent(recipie.label)
      imageData = UIImage(contentsOfFile: fileURL.path)
    } else {
      imageData = UIImage(systemName: "exclamationmark.triangle")
    }
  }
  var body: some View {
    NavigationView {
      if !dataStore.recipies.isEmpty {
        List {
          if !filteredRecipies.isEmpty {
            ForEach(filteredRecipies) { recipie in
              NavigationLink {
                SavedRecipieDetailView(recipie: recipie, imageData: $imageData, dataStore: dataStore)
                  .onAppear {
                    loadImageData(recipie: recipie)
                  }
                  .toolbar {
                    SavedRecipieToolbarButtonView(dataStore: dataStore, recipie: recipie)
                  }
              } label: {
                Text("\(recipie.label)")
              }
            }
          } else {
            Text("No results for \(savedRecipieSearchText)")
          }
        }
        .searchable(text: $savedRecipieSearchText, prompt: "Type here to search")
      } else {
        Text("No Saved Recipes")
      }
    }
    .onAppear {
      if let data = UserDefaults.standard.data(forKey: "savedRecipies") {
        if let decoded = try? JSONDecoder().decode([Recipie].self, from: data) {
          dataStore.recipies = decoded
        }
      }
    }
  }
}

#Preview {
  @ObservedObject var dataStore = DataStore()
  return VStack {
    SavedRecipiesView(dataStore: dataStore)
  }
}
