//
//  ViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/17.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ViewModel {

    let tasks = BehaviorRelay<[TaskOfRealm]>(value: [])
    
    private let realm = try! Realm()

    init() {
        if realm.objects(TasksOfRealm.self).isEmpty == false {
            tasks.accept(Array(realm.objects(TasksOfRealm.self)[0].taskList))
        }
    }

    func addToRealm(value: [TaskOfRealm]) {
        tasks.accept(tasks.value + value)
        var dic:[[String:Any]]! = []
        for task in tasks.value {
            dic.append(["title":task.title])
        }
        try! realm.write {
            realm.add(TasksOfRealm(value: ["taskList":dic]), update: .modified)
        }
    }
    
//    func getArrayOfTaskOfRealmAfterDeletedElement(value: [TaskOfRealm], indexPathRow: Int) -> [TaskOfRealm] {
//        var tasksArray = value
//        tasksArray.remove(at: indexPathRow)
//        return tasksArray
//    }
}
