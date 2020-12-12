//
//  CounterRxViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import RxSwift
import RxCocoa

struct CounterViewModelInput {
    // Observable:イベントを検知
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
        input.countUpButton // イベント元
            // .subscribe(OnNext:...)でOnErrorとOnCompletedを省略した書き方
            .subscribe(onNext: { [weak self] in
                self!.incrementCount() // イベント処理
            })
            .disposed(by: disposeBag) // 購読を破棄

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
        countRelay.accept(count) // countRelayに+1のイベントを送信
    }

    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count) // countRelayに-1のイベントを送信
    }

    private func resetCount() {
        countRelay.accept(initialCount) // countRelayに0に初期化のイベントを送信
    }
}

extension CounterRxViewModel: CounterViewModelOutput {
    var counterText: Driver<String?> {
        return countRelay
            .map {"Rxパターン:\($0)"} // countRelayのイベント値を出力
            .asDriver(onErrorJustReturn: nil) // エラーが起きたらnilを通知？
    }
}
