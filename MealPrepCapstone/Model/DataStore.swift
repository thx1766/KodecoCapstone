//
//  DataStore.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import Foundation

class DataStore: ObservableObject {
  @Published var recipies: [Recipie] = []
  @Published var loadingData = false
  @Published var firstRun = true
  @Published var hasRunBefore = false
  @Published var dismissOnboarding = false
  @Published var searchList = RecipieResults(hits: nil)

  func deleteFileFromSavedImages(label: String) {
    let fileManager = FileManager.default
    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      print("Documents Directory \(documentsDirectory)")
      let fileURL = documentsDirectory.appendingPathComponent(label)
      do {
        try fileManager.removeItem(at: fileURL)
        print("File deleted: \(fileURL)")
      } catch {
        print("Error deleting file")
      }
    }
  }

  func addFileToSavedImages(image: String, label: String) async {
    print("image: \(image)")
    let fileManager = FileManager.default
    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      let fileURL = documentsDirectory.appendingPathComponent(label)
      do {
        if let url = URL(string: image) {
          let (data, _) = try await URLSession.shared.data(from: url)
          try data.write(to: fileURL)
          print("File copied to: \(fileURL)")
        } else {
          print("Error loading image")
        }
      } catch {
        print("Error copying file")
      }
    }
    DispatchQueue.main.async {
      self.loadingData = false
    }
    //
  }

  init() {
    if let data = UserDefaults.standard.data(forKey: "savedRecipies") {
      if let decoded = try? JSONDecoder().decode([Recipie].self, from: data) {
        recipies = decoded
      }
    }
    print("hasRunBefore \(UserDefaults.standard.bool(forKey: "hasRunBefore"))")
  }
}
