//
//  Create&UpdateVC.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/14.
//

import UIKit
import RxSwift
import RxCocoa

class CreateAndUpdateVC: UIViewController {

    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()

    private var textField = UITextField()
    var textOfSelectedCell:String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let text = textOfSelectedCell else {
            self.title = "追加"
            return
        }
        textField.text = text
        self.title = "編集"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    private func setupViewController() {
        self.navigationController?.title = "追加/編集"

        // textFieldのView設定
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.borderStyle = .roundedRect
        textField.placeholder = "タスク名を入力"
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        // BarButtonItemの設定
        let presentAddVCBarButton = UIBarButtonItem()
        presentAddVCBarButton.title = "追加"
        presentAddVCBarButton.rx.tap
            .subscribe(onNext: { [self] in
                viewModel = ViewModel()
                viewModel.addToRealm(value: [TaskOfRealm(title: textField.text!)])
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = presentAddVCBarButton

        // textFieldのobserve設定
        textField.rx.text.asDriver()
            .drive(onNext: { text in
                guard let text = text else {return}
                if text.isEmpty {
                    presentAddVCBarButton.isEnabled = false
                    presentAddVCBarButton.tintColor = UIColor.clear
                } else {
                    presentAddVCBarButton.isEnabled = true
                    presentAddVCBarButton.tintColor = UIColor.link
                }
            }).disposed(by: disposeBag)
    }

}
