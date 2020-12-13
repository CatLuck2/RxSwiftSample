//
//  AlertModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/13.
//

import UIKit

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style

    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}
