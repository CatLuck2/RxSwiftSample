//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/11.
//

import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countUpButton: UIButton!
    @IBOutlet weak var countDownButton: UIButton!
    @IBOutlet weak var countResetButton: UIButton!

    private let disposeBag = DisposeBag()
    private var viewModel: CounterRxViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    private func setupViewModel() {
        viewModel = CounterRxViewModel()
        let input = CounterViewModelInput (
            countUpButton: countUpButton.rx.tap.asObservable(),
            countDownButton: countDownButton.rx.tap.asObservable(),
            countResetButton: countResetButton.rx.tap.asObservable())
        viewModel.setup(input: input)
        viewModel.outputs?.counterText
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }

}

