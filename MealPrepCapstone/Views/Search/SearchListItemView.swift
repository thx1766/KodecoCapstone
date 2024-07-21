//
//  SearchListItemView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SearchListItemView: View {
  @State var hit: RecipieResult
  var body: some View {
    HStack {
      Text(hit.recipe.label)
      if let url = URL(string: hit.recipe.image) {
        AsyncImage(url: url) { result in
          result
            .image?
            .resizable()
            .scaledToFit()
        }
        .frame(width: 100, height: 100)
      } else {
        Text("(no image)")
      }
    }
  }
}

#Preview {
  SearchListItemView(hit:
    RecipieResult(recipe:
      RecipieJSON(
        label: "label",
        image: "image",
        url: "",
        ingredientLines: ["ingredient"]
      )
    )
  )
}
