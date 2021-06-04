//
//  Activity.swift
//  task-tracker-swiftui
//
//  Created by Nina Paripovic on 6/4/21.
//

import Foundation
import RealmSwift

@objcMembers class Activity: Object, Identifiable {
    dynamic var _id = 0
    dynamic var title = ""

    override static func primaryKey() -> String? {
      "_id"
    }
}
