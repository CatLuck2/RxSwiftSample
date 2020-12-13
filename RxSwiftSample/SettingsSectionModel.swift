//
//  SettingsSectionModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import UIKit
import RxDataSources

typealias SettingsSectionModel = SectionModel<SettingsSection, SettingsItem>

// セクション
enum SettingsSection {
    case account
    case common
    case original

    var headerHeight: CGFloat {
        return 40.0
    }

    var footerHeight: CGFloat {
        return 1.0
    }
}

// セル
enum SettingsItem {
    // セルの識別名
    // account
    case account
    case security
    case notification
    case contents
    // common
    case sounds
    case dataUsing
    case accessibility
    // original
    case one
    case two
    // other
    case description(text: String)

    // セルのテキスト
    var title: String? {
        switch self {
        case .account:
            return "１"
        case .security:
            return "2"
        case .notification:
            return "3"
        case .contents:
            return "4"
        case .sounds:
            return "5"
        case .dataUsing:
            return "6"
        case .accessibility:
            return "7"
        case .one:
            return "8"
        case .two:
            return "9"
        case .description:
            return nil
        }
    }

    // セルの高さ
    var rowHeight: CGFloat {
        switch self {
        case .description:
            return 72.0
        default:
            return 48.0
        }
    }

    // セルの装飾
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .account, .security, .notification, .contents, .sounds, .dataUsing, .accessibility, .one, .two:
            return .disclosureIndicator
        case .description:
            return .none
        }
    }
}
