//
//  SettingsViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//　Modelを用いてViewに最適な形の値を返せる変数と関数を用意、ViewがViewModelを参照するだけでTableViewを表示させる役割

import RxSwift
import RxCocoa
import RxDataSources

class SettingsViewModel {

    // cellのデータ変更をdataSourceに通知
    let items = BehaviorRelay<[SettingsSectionModel]>(value: [])

    var itemsObservable: Observable<[SettingsSectionModel]> {
        return items.asObservable()
    }

    func setup() {
        updateItem()
    }

    func updateItem() {
        let sections: [SettingsSectionModel] = [accountSection(),commonSection(),originalSection()]
        items.accept(sections)
    }

    // accountセクション
    private func accountSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .account,
            .security,
            .notification,
            .contents
        ]
        return SettingsSectionModel(model: .account, items: items)
    }

    // commonセクション
    private func commonSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .sounds,
            .dataUsing,
            .accessibility,
        ]
        return SettingsSectionModel(model: .common, items: items)
    }

    // originalセクション
    private func originalSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .one,
            .two,
            .description(text: "基本設定はこの端末でログインしている全てのアカウントに適用されます")
        ]
        return SettingsSectionModel(model: .original, items: items)
    }

}
