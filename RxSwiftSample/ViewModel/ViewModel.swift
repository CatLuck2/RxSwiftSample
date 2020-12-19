//
//  ViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/17.
//

import Foundation
import RealmSwift

class ViewModel {
    func addToRealm(value: [TaskOfRealm]) {
        let realm = try! Realm()
        var dic:[[String:Any]]! = []
        for task in value {
            dic.append(["title":task.title])
        }
        let testTask = TasksOfRealm(value: ["taskList":dic])
        try! realm.write {
            realm.add(testTask, update: .modified)
        }
    }
    func getArrayOfTaskOfRealmAfterDeletedElement(value: [TaskOfRealm], indexPathRow: Int) -> [TaskOfRealm] {
        var tasksArray = value
        tasksArray.remove(at: indexPathRow)
        return tasksArray
    }
}
