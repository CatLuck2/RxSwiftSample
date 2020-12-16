//
//  Task.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/14.
//

import Foundation
import RealmSwift

struct Task {
    var title: String
}

class TaskOfRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}
