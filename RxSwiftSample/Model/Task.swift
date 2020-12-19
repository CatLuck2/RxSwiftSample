//
//  Task.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/14.
//

import Foundation
import RealmSwift

class TaskOfRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var id: Int = 1

    convenience init(title:String) {
        self.init()
        self.title = title
    }
}

class TasksOfRealm: Object {
    var taskList = List<TaskOfRealm>()
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}
