//
//  ActivityStore.swift
//  task-tracker-swiftui
//
//  Created by Nina Paripovic on 6/4/21.
//

import Foundation
import RealmSwift

final class ActivityStore: ObservableObject {
  private var ActivityResults: Results<Activity>

  init(realm: Realm) {
    ActivityResults = realm.objects(Activity.self)

  }

  var activities: [Activity] {
    ActivityResults.map(Activity.init)
  }
}

// MARK: - CRUD Actions
extension ActivityStore {
  func create(title: String) {
    objectWillChange.send()

    do {
      let realm = try Realm()

      let activity = Activity()
        activity._id = UUID().hashValue
        activity.title = title

      try realm.write {
        realm.add(activity)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }

//  func toggleBought(ingredient: Ingredient) {
//    objectWillChange.send()
//    do {
//      let realm = try Realm()
//      try realm.write {
//        realm.create(
//          IngredientDB.self,
//          value: ["id": ingredient.id, "bought": !ingredient.bought],
//          update: .modified)
//      }
//    } catch let error {
//      // Handle error
//      print(error.localizedDescription)
//    }
//  }

  func update(
    activityID: Int,
    title: String,
    notes: String,
    quantity: Int,
    colorName: String
  ) {
    objectWillChange.send()
    do {
      let realm = try Realm()
      try realm.write {
        realm.create(
          Activity.self,
          value: [
            "_id": activityID,
            "title": title
          ],
          update: .modified)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }

  func delete(activityID: Int) {
    // 1
    objectWillChange.send()
    // 2
    guard let activity = ActivityResults.first(
      where: { $0._id == activityID })
      else { return }

    do {
      let realm = try Realm()
      try realm.write {
        realm.delete(activity)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }
}
