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

    private var disposeBag = DisposeBag()
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    private func setupViewController() {
        self.navigationController?.title = "追加/編集"

        // textFieldの設定
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.borderStyle = .roundedRect
        textField.placeholder = "タスク名を入力"
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        // BarButtonItemの設定
        let presentAddVC = UIBarButtonItem()
        presentAddVC.title = "追加"
        presentAddVC.rx.tap
            .subscribe(onNext: { [self] in
                taskSubject.onNext(Task(title: textField.text!))
                navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = presentAddVC
    }

}
