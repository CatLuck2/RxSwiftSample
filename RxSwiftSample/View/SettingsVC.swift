//
//  SettingsVC.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//　ライフサイクルメソッドを用いてViewを描画、
/*
 RxDataSourcesを使って変わること
 ・delegateメソッドの大半が不要
 ・セクションとセルの値や設定を別ファイルで整理できた
 ・rx.itemDelete, rx.itemSelected、のように、rx.状態/プロパティ、で変更を検知し、次に実行する処理をかける

 メモ
 ・ObserVable<>.subscribe({})でObserVableの処理を実行
 */

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

final class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var viewModel:SettingsViewModel! = SettingsViewModel(taskModel: SharedModel.instance)
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
    }

    // 起動時の設定
    private func setupViewController() {
        // BarButtonItemの設定
        let presentAddVC = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        presentAddVC.rx.tap
            .subscribe(onNext: {
                let vc = CreateAndUpdateVC(nibName: "CreateAndUpdateVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = presentAddVC
    }

    // TableViewの設定
    private func setupTableView() {
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
        // セルの読み込み
        viewModel.tasksObservable
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "customcell") as! CustomCell
                cell.textLabel?.text = element.title
                return cell
            }.disposed(by: disposeBag)

        // itemSelected時にsubscribe(タップされたら購読)
        tableView.rx.itemSelected
            .subscribe(onNext: { [self] indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
                let vc = CreateAndUpdateVC(nibName: "CreateAndUpdateVC", bundle: nil)
                guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
                vc.textOfSelectedCell = text
                vc.rowOfSelectedCell = indexPath.row
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)

        // セルが削除された時
        tableView.rx.itemDeleted
            .subscribe(onNext: { [self] indexPath in
                guard indexPath.isEmpty == false else { return }
                // Realmのデータを削除
                viewModel.delete(indexPathRow: indexPath.row)
                tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}
