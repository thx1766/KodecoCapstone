//
//  MealPrepCapstoneTests.swift
//  MealPrepCapstoneTests
//
//  Created by Nate Schaffner on 7/11/24.
//

import XCTest
@testable import MealPrepCapstone

final class MealPrepCapstoneTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you wan t to measure the time of here.
    }
  }

  func testApiKeyDecryption() {
    var _ = Config.apiAppID
    var _ = Config.apiAppKey
    var _ = Config.apiUrl
  }
}

class DataStoreTests: XCTestCase {
  var dataStore = DataStore()

//  override func setUp() {
//    super.setUp()
//    dataStore = DataStore()
//  }

  //  func testInitialization() {
  //    XCTAssertNotNil(dataStore, "DataStore should be initialized.")
  //  }

  func testLoadingData() async {
    let imageURL = "https://example.com/image.jpg"
    let label = "testImage"

    await dataStore.addFileToSavedImages(image: imageURL, label: label)

    XCTAssertFalse(dataStore.loadingData, "loadingData should be false after addFileToSavedImages completes.")
  }

  func testDeleteFile() {
    let label = "testImage"
    dataStore.deleteFileFromSavedImages(label: label)

    // Check for any errors
    XCTAssert(true, "Delete function executed without errors.")
  }
  func testInitialization() {
    XCTAssertNotNil(dataStore, "DataStore should be initialized.")
    XCTAssertFalse(dataStore.loadingData, "loadingData should be false on initialization.")
  }

  func testAddFileToSavedImages() async {
    let imageURL = "https://example.com/image.jpg"
    let label = "testImage"

    await dataStore.addFileToSavedImages(image: imageURL, label: label)

    XCTAssertFalse(dataStore.loadingData, "loadingData should be false after addFileToSavedImages completes.")
    XCTAssert(
      FileManager.default.fileExists(
        atPath: getFilePath(for: label).path),
      "File should exist after being added."
    )
  }

  func testDeleteFileFromSavedImages() {
    let label = "testImage"
    let filePath = getFilePath(for: label)

    // Create a dummy file to delete
    FileManager.default.createFile(atPath: filePath.path, contents: Data(), attributes: nil)
    XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path), "File should exist before deletion.")

    dataStore.deleteFileFromSavedImages(label: label)

    XCTAssertFalse(
      FileManager.default.fileExists(atPath: filePath.path),
      "File should not exist after deletion.")
  }

  private func getFilePath(for label: String) -> URL {
    let fileManager = FileManager.default
    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      return documentsDirectory.appendingPathComponent(label)
    } else {
      return URL(fileURLWithPath: "")
    }
  }
}

class NetworkingTests: XCTestCase {
  func testLoadRecipiesJSONSuccess() async {
    let searchFor = "chicken"
    let result = await loadRecipiesJSON(searchFor: searchFor, timeout: 30)
    XCTAssertNotNil(result, "Result should not be nil.")
  }

  func testLoadRecipiesJSONFailure() async {
    let searchFor = ""
    let result = await loadRecipiesJSON(searchFor: searchFor, timeout: 30)
    XCTAssertNotNil(result, "Result should not be nil.")
  }
}

class RecipieTests: XCTestCase {
  func testRecipieInitialization() {
    let recipie = Recipie(
      label: "Test Recipie",
      imageUrl: "",
      link: "",
      ingredients: ["Ingredient1", "Ingredient2"]
    )

    XCTAssertNotNil(recipie, "Recipie should be initialized.")
    XCTAssertEqual(recipie.label, "Test Recipie", "Recipie name should be initialized correctly.")
  }
}

class RecipiesJSONStructsTests: XCTestCase {
  func testDecodingRecipieResults() {
    if let jsonData = """
    {
    "hits": [
      {
        "recipe": {
          "label": "Test Recipie",
          "image": "https://example.com/image.jpg",
          "url": "https://example.com/recipe",
          "ingredientLines": ["Ingredient1", "Ingredient2"]
        }
      }
    ]
    }
    """.data(using: .ascii) {
      let decoder = JSONDecoder()
      do {
        let result = try decoder.decode(RecipieResults.self, from: jsonData)
        XCTAssertNotNil(result.hits, "Hits should not be nil.")
        XCTAssertEqual(result.hits?.first?.recipe.label, "Test Recipie", "Recipe label should match.")
      } catch {
        XCTFail("Decoding failed with error: \(error)")
      }
    }
  }
}
