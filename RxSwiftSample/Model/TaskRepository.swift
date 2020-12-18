//
//  TaskRepository.swift
//  RxSwiftSample
//
//  Created by akio0911 on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class TaskRepository {
    private let tasksRelay = BehaviorRelay<[TaskOfRealm]>(value: [])
    var tasks: Observable<[TaskOfRealm]> {
        tasksRelay.asObservable()
    }
    
    private let realm = try! Realm()
    
    init() {
        if realm.objects(TasksOfRealm.self).isEmpty == false {
            tasksRelay.accept(Array(realm.objects(TasksOfRealm.self)[0].taskList))
        }
    }
    
    func add(value: [TaskOfRealm]) {
        tasksRelay.accept(tasksRelay.value + value)
        var dic:[[String:Any]]! = []
        for task in tasksRelay.value {
            dic.append(["title":task.title])
        }
        try! realm.write {
            realm.add(TasksOfRealm(value: ["taskList":dic]), update: .modified)
        }
    }
}

struct ModelLocator {
    static let shared = ModelLocator()
    
    let taskRepository = TaskRepository()
    
    private init() {}
}
