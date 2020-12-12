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

    init() {
        self.outputs = self
        resetCount()
    }

    func setup(input: CounterViewModelInput) {
        input.countUpButton
            .subscribe(onNext: { [weak self] in
                self!.incrementCount()
            })
            .disposed(by: disposeBag)

        input.countDownButton
            .subscribe(onNext: { [weak self] in
                self!.decrementCount()
            })
            .disposed(by: disposeBag)

        input.countResetButton
            .subscribe(onNext: { [weak self] in
                self!.resetCount()
            })
            .disposed(by: disposeBag)
    }

    private func incrementCount() {
        let count = countRelay.value + 1
        countRelay.accept(count)
    }

    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count)
    }

    private func resetCount() {
        countRelay.accept(initialCount)
    }
}

extension CounterRxViewModel: CounterViewModelOutput {
    var counterText: Driver<String?> {
        return countRelay
            .map {"Rxパターン:\($0)"}
            .asDriver(onErrorJustReturn: nil)
    }
}
