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

    convenience init(title:String) {
        self.init()
        self.title = title
    }

//    required init() {
//        fatalError("init() has not been implemented")
//    }
}

class TasksOfRealm: Object {
    var taskList = List<TaskOfRealm>()
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}
