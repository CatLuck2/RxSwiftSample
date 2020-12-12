//
//  CounterRxViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import RxSwift
import RxCocoa

struct CounterViewModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

protocol CounterViewModelOutput {
    var counterText: Driver<String?> {get}
}

protocol CounterViewModelType {
    var outputs: CounterViewModelOutput? {get}
    func setup(input: CounterViewModelInput)
}

class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewModelOutput?

    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()

    func setup(input: CounterViewModelInput) {

    }
}
