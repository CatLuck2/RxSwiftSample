//
//  CreateAndUpdateViewModel.swift
//  RxSwiftSample
//
//  Created by akio0911 on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class CreateAndUpdateViewModel {
    private let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func add(value: [TaskOfRealm]) {
        taskRepository.add(value: value)
    }
}
