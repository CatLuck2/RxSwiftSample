//
//  SettingsViewModel.swift
//  RxSwiftSample
//
//  Created by akio0911 on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class SettingsViewModel {
    private let taskRepository: TaskRepository
    
    var tasks: Observable<[TaskOfRealm]> {
        taskRepository.tasks
    }
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
}
