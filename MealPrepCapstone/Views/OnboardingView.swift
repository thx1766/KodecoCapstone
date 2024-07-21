//
//  OnboardingView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/14/24.
//

import SwiftUI

#Preview {
  @ObservedObject var dataStore = DataStore()
  return OnboardingView(dataStore: dataStore)
}

enum PreviewViewSelected {
  case none
  case searchView
  case savedRecipiesView
  case settingsView
}

struct PreviewView: View {
  @State var selected: PreviewViewSelected
  @ObservedObject var dataStore: DataStore

  var body: some View {
    VStack {
      if selected == .searchView {
        VStack {
          SearchView(dataStore: DataStore())
            .padding()
        }
        .border(Color.black)
      } else if selected == .savedRecipiesView {
        VStack {
          SavedRecipiesView(dataStore: DataStore())
            .padding()
        }
        .border(Color.black)
      } else if selected == .settingsView {
        VStack {
          SettingsView(dataStore: DataStore(), hideOnboarding: .constant(false))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .border(Color.black)
      } else {
        EmptyView()
      }
    }
  }
}

struct OnboardingSubView: View {
  @State var text: String
  @Binding var viewCount: Int
  @State var previewViewSelected: PreviewViewSelected
  @ObservedObject var dataStore: DataStore
  @State var tabImage: String
  @State var tabName: String

  var body: some View {
    VStack {
      Spacer()
      Text(text)
        .padding()
      Spacer()
      PreviewView(selected: previewViewSelected, dataStore: dataStore)
        .padding()
      Spacer()
      HStack {
        if viewCount > 0 {
          Button {
            viewCount -= 1
          } label: {
            Text("Previous")
          }
        }
        Spacer()
        VStack {
          Image(systemName: tabImage)
          Text(tabName)
        }
        Spacer()
        Button {
          if viewCount == 3 {
            dataStore.dismissOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
          } else {
            viewCount += 1
          }
        } label: {
          if viewCount == 3 {
            Text("Done")
          } else {
            Text("Next")
          }
        }
      }
      .padding()
      Spacer()
    }
  }
}

struct OnboardingView: View {
  @State var screen = 0
  @ObservedObject var dataStore: DataStore
  var body: some View {
    VStack {
      Spacer()
      if screen == 0 {
        OnboardingSubView(
          text:
            """
            Welcome to Meal Prep Capstone!
            This app uses the Edemam API to search for recipies.
            """,
          viewCount: $screen,
          previewViewSelected: .none,
          dataStore: dataStore,
            tabImage: "",
            tabName: ""
        )
      } else if screen == 1 {
        OnboardingSubView(
          text:
            """
            Use the search bar to find recipies. Try it out and save one!
            """,
          viewCount: $screen,
          previewViewSelected: .searchView,
          dataStore: dataStore,
          tabImage: "magnifyingglass",
          tabName: "Search"
        )
      } else if screen == 2 {
        OnboardingSubView(
          text:
            """
            Saved recipies appear on your home tab.
            """,
          viewCount: $screen,
          previewViewSelected: .savedRecipiesView,
          dataStore: dataStore,
          tabImage: "house",
          tabName: "Home"
        )
      } else if screen == 3 {
        OnboardingSubView(
          text:
            """
            In settings, you can return to this tutorial.
            """,
          viewCount: $screen,
          previewViewSelected: .settingsView,
          dataStore: dataStore,
          tabImage: "gearshape.fill",
          tabName: "Settings"
        )
      }
      Spacer()
      Image("Edamam_Badge_Transparent")
    }
  }
}
