//
//  CreateAndUpdateViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/19.
//

import Foundation
import RxSwift

final class CreateAndUpdateViewModel {

    private let taskModel: TaskModel!

    var tasksObservable: Observable<[TaskOfRealm]> {
        taskModel.tasksObservable
    }

    init(taskModel:TaskModel) {
        self.taskModel = taskModel
    }

    func add(newValues: [TaskOfRealm]) {
        taskModel.addToRealm(newValues: newValues)
    }

    func edit(newValue: String? = nil, indexPathRow: Int? = nil) {
        taskModel.updateRealmForEdit(newValue: newValue, indexPathRow: indexPathRow)
    }

}
