//
//  SearchView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

struct SearchView: View {
  @State var isSearching = false
  @State var networkError = false
//  @State var recipiesList = RecipieResults(hits: nil)
  @State var recipieApiSearchText = ""
  @State var recipieApisearchTextSearch = ""
  @State var timeout = 3.0
  @ObservedObject var dataStore: DataStore

  func searchFor(text: String) async {
    print("Searching for: \(text)")
    recipieApisearchTextSearch = text
    if let searchList = await loadRecipiesJSON(searchFor: text, timeout: timeout) {
      dataStore.searchList = searchList
    } else {
      networkError = true
      print("NetworkError: Could not load recipies.")
    }
  }

  var body: some View {
    NavigationView {
      List {
        if !isSearching {
          if let recipiesListHits = dataStore.searchList.hits {
            if !recipiesListHits.isEmpty {
              ForEach(dataStore.searchList.hits ?? [], id: \.id) { hit in
                NavigationLink {
                  ZStack {
                    SearchDetailView(hit: hit)
                      .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                          SearchToolbarButtonView(dataStore: dataStore, hit: hit)
                        }
                      }
                  }
                } label: {
                  SearchListItemView(hit: hit)
                }
              }
            } else if recipieApiSearchText.isEmpty {
              Text("No Results for \(recipieApisearchTextSearch)")
            }
          }
        } else {
          VStack {
            Text("Searching...")
            ProgressView()
            Spacer()
          }
        }
      }
      .searchable(text: $recipieApiSearchText, prompt: "Type here to search")
      .onSubmit(of: .search) {
        Task {
          isSearching = true
          await searchFor(text: recipieApiSearchText)
          isSearching = false
        }
      }
    }.sheet(isPresented: $networkError) {
      Text("Network Error!")
      Text("Double the timeout and try again?")
      HStack {
        Button {
          networkError = false
          timeout *= 2
          isSearching = true
          Task {
            await searchFor(text: recipieApiSearchText)
            isSearching = false
          }
        } label: {
          Text("Try Again")
        }
        Button {
          networkError = false
        } label: {
          Text("Cancel")
        }
      }
    }
  }
}

#Preview {
  @ObservedObject var dataStore = DataStore()
  return VStack {
    SearchView(dataStore: dataStore)
  }
}
