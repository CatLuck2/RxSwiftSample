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

struct SharedViewModel {
    // 共有インスタンス
    static let instance = ViewModel()
}

class ViewModel {

    let tasks = BehaviorRelay<[TaskOfRealm]>(value: [])

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

    func updateRealm(newValue: String? = nil, indexPathRow: Int? = nil) {
        guard let text = newValue,
              let row = indexPathRow else {
            // 削除
            saveProcessOfRealm(valueForSave: tasks.value)
            return
        }
        // 編集
        let array = tasks.value
        try! realm.write {
            // Realmへの保存
            array[row].title = text
        }
        // tasksの更新
        tasks.accept(array)
    }
    
    func getArrayOfTaskOfRealmAfterDeletedElement(value: [TaskOfRealm], indexPathRow: Int) -> [TaskOfRealm] {
        var array = value
        array.remove(at: indexPathRow)
        return array
    }
}
