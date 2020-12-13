//
//  SettingsVC.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var disposeBag = DisposeBag()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SettingsSectionModel>(configureCell: configureCell)

    // cellForRowAtの役割ーセルを返す
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SettingsSectionModel>.ConfigureCell =
        { [weak self]  (dataSource, tableView, indexPath, _) in
            let item = dataSource[indexPath]
            switch item {
            case .account, .security, .notification, .contents, .sounds, .dataUsing, .accessibility, .one, .two:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.title
                return cell
            case .description(let text):
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = text
                cell.isUserInteractionEnabled = false
                return cell
            }
    }

    private var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        setupTableView()
        setupViewModel()
    }

    // 起動時の設定
    private func setupViewController() {
        navigationItem.title = "設定"
    }

    // TableViewの設定
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset.bottom = 12.0
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        // didTapSelectRowAt-セルをタップ時の処理
        // 手続き形式ではなく、宣言のように処理を登録
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let item_ = self?.dataSource[indexPath] else {return}
                self?.tableView.deselectRow(at: indexPath, animated: true)
                // タップ後の処理などを記述
            })
            .disposed(by: disposeBag)
    }

    private func setupViewModel() {
        viewModel = SettingsViewModel()
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.updateItem()
    }

}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath]
        return item.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = dataSource[section]
        return section.model.headerHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let section = dataSource[section]
        return section.model.footerHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .lightGray
        return footerView
    }
}
