//
//  SearchDetailView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SearchDetailView: View {
  @State var hit: RecipieResult
  @State var errorOpeningLink = false

  var body: some View {
    VStack {
      if true {
        Text(hit.recipe.label)
      }
      if let url = URL(string: hit.recipe.image) {
        AsyncImage(url: url) { image in
          image.resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
      } else {
        Image(systemName: "exclamationmark.triangle")
      }
      Button(action: {
        if let url = URL(string: hit.recipe.url) {
          UIApplication.shared.open(url)
        } else {
          errorOpeningLink = true
        }
      }, label: {
        Text("Open Recipe in Browser")
      })
      Text("Ingredients")
        .font(.title)
      List {
        ForEach(hit.recipe.ingredientLines, id: \.self) { ingredient in
          Text(ingredient)
        }
      }
    }
    .sheet(isPresented: $errorOpeningLink) {
      Text("Error opening link")
      Button("Dismiss") {
        errorOpeningLink = false
      }
    }
  }
}

#Preview {
  SearchDetailView(hit:
    RecipieResult(recipe:
      RecipieJSON(
        label: "label",
        image: "image",
        url: "url",
        ingredientLines: ["ingredient1", "ingredient2"]
      )
    )
  )
}
