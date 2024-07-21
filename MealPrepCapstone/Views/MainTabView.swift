//
//  MainTabView.swift
//  MealPrepCapstone
//
//  Created by Nate Schaffner on 7/11/24.
//

import SwiftUI

struct MainTabView: View {
  @ObservedObject var dataStore = DataStore()
  @State var isAnimating = false
  @State var isRotating = 0.0
  @State var hideOnboarding = UserDefaults.standard.bool(forKey: "hasRunBefore")
  var body: some View {
    VStack {
      if hideOnboarding || dataStore.dismissOnboarding {
        if dataStore.loadingData {
          HStack {
            Text(isAnimating ? "Saving Data" : "")
              .animation( .easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
            Image(systemName: "icloud.circle.fill")
              .rotationEffect(.degrees(isRotating))
              .onAppear {
                withAnimation(.linear(duration: 1).speed(0.3).repeatForever(autoreverses: false)) {
                  isRotating += 360.0
                }
              }
          }
          .onAppear {
            isAnimating = true
          }
          .onDisappear {
            isAnimating = false
          }
        }
        TabView {
          SearchView(dataStore: dataStore)
            .tabItem {
              Image(systemName: "magnifyingglass")
              Text("Search")
            }
          SavedRecipiesView(dataStore: dataStore)
            .tabItem {
              Image(systemName: "house")
              Text("Home")
            }
          SettingsView(dataStore: dataStore, hideOnboarding: $hideOnboarding)
            .tabItem { Image(systemName: "gearshape.fill")
              Text("Settings")
            }
        }
      } else {
        OnboardingView(dataStore: dataStore)
      }
    }
  }
}

struct SettingsView: View {
  @ObservedObject var dataStore: DataStore
  @Binding var hideOnboarding: Bool
  var body: some View {
    Button(action: {
      UserDefaults.standard.set(false, forKey: "hasRunBefore")
      hideOnboarding = false
      dataStore.dismissOnboarding = false
    }, label: {
      Text("Repeat Onboarding")
    })
  }
}

#Preview {
  MainTabView()
}
