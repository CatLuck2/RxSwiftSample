//
//  AlertViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/13.
//

import UIKit
import RxSwift
import RxCocoa

class AlertViewModel {
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction]) -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }

            

            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
