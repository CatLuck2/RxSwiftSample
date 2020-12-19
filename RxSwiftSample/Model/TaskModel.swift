//
//  Model.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/19.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct SharedModel {
    // 共有インスタンス
    static let instance = TaskModel()
}

final class TaskModel {
    let tasks = BehaviorRelay<[TaskOfRealm]>(value: [])
    var tasksObservable: Observable<[TaskOfRealm]> {
        tasks.asObservable()
    }

    private let realm = try! Realm()

    init() {
        if realm.objects(TasksOfRealm.self).isEmpty == false {
            tasks.accept(Array(realm.objects(TasksOfRealm.self)[0].taskList))
        }
    }

    private func saveProcessOfRealm(valueForSave: [TaskOfRealm]) {
        var dic:[[String:Any]]! = []
        for task in tasks.value {
            dic.append(["title":task.title])
        }
        try! realm.write {
            realm.add(TasksOfRealm(value: ["taskList":dic]), update: .modified)
        }
    }

    func addToRealm(newValues: [TaskOfRealm]) {
        tasks.accept(tasks.value + newValues)
        saveProcessOfRealm(valueForSave: tasks.value)
    }

    func updateRealmForEdit(newValue: String? = nil, indexPathRow: Int? = nil) {
        guard let text = newValue,
              let row = indexPathRow else {
            return
        }
        try! realm.write {
            // Realmへの保存
            tasks.value[row].title = text
        }
        // tasksの更新
        tasks.accept(self.tasks.value)
    }

    func updateRealmForDelete(value: [TaskOfRealm], indexPathRow: Int) {
        var array = value
        array.remove(at: indexPathRow)
        tasks.accept(array)
        saveProcessOfRealm(valueForSave: tasks.value)
    }
}
