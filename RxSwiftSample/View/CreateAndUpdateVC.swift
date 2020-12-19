//
//  Create&UpdateVC.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/14.
//


import UIKit
import RxSwift
import RxCocoa

final class CreateAndUpdateVC: UIViewController {

    var viewModel: CreateAndUpdateViewModel! = CreateAndUpdateViewModel(taskModel: SharedModel.instance)
    private var disposeBag = DisposeBag()
    var textOfSelectedCell:String? = nil
    var rowOfSelectedCell:Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    private func setupViewController() {

        // textFieldのView設定
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.text = textOfSelectedCell ?? ""
        textField.borderStyle = .roundedRect
        textField.placeholder = "タスク名を入力"
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        // BarButtonItemの設定
        let presentAddVCBarButton = UIBarButtonItem()
        if textOfSelectedCell == nil {
            self.title = "タスクを追加"
            presentAddVCBarButton.title = "追加"
        } else {
            self.title = "タスクを編集"
            presentAddVCBarButton.title = "更新"
        }
        presentAddVCBarButton.rx.tap
            .subscribe(onNext: { [self] in
                if let row = rowOfSelectedCell {
                    viewModel.edit(newValue: textField.text!, indexPathRow: row)
                } else {
                    guard let text = textField.text else { return }
                    viewModel.add(newValues: [TaskOfRealm(title: text)])
                }
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
