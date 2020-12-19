//
//  SettingsViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/19.
//

import Foundation
import RxSwift

final class SettingsViewModel {

    private let taskModel: TaskModel!

    var tasksObservable: Observable<[TaskOfRealm]> {
        taskModel.tasksObservable
    }

    init(taskModel:TaskModel) {
        self.taskModel = taskModel
    }

    func delete(indexPathRow: Int) {
        taskModel.updateRealmForDelete(value: taskModel.tasks.value, indexPathRow: indexPathRow)
    }
    
}
