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

class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var viewModel:ViewModel!
    private var disposeBag = DisposeBag()
    // 選択されたセルの番号
    private var numOfSelectedCell:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
    }

    // 起動時の設定
    private func setupViewController() {
        self.navigationController?.delegate = self
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
        viewModel = ViewModel()
        viewModel.tasks.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "customcell") as! CustomCell
                cell.textLabel?.text = element.title
                return cell
            }.disposed(by: disposeBag)

        // itemSelected時にsubscribe(タップされたら購読)
//        tableView.rx.itemSelected
//            .subscribe(onNext: { [self] indexPath in
//                numOfSelectedCell = indexPath.row
//                tableView.deselectRow(at: indexPath, animated: true)
//                let vc = CreateAndUpdateVC(nibName: "CreateAndUpdateVC", bundle: nil)
//                vc.textOfSelectedCell = tasks.value[indexPath.row].title
//                navigationController?.pushViewController(vc, animated: true)
//            }).disposed(by: disposeBag)
//
//        // セルが削除された時
//        tableView.rx.itemDeleted
//            .subscribe(onNext: { [self] indexPath in
//                guard indexPath.isEmpty == false else { return }
//                // Realmのデータを削除
//                let viewModel = ViewModel()
//                tasks.accept(viewModel.getArrayOfTaskOfRealmAfterDeletedElement(value: tasks.value, indexPathRow: indexPath.row))
//                viewModel.addToRealm(value: tasks.value)
//                tableView.reloadData()
//            }).disposed(by: disposeBag)
    }
}

extension SettingsVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.tableView.reloadData()
//        guard let vc = viewController as? CreateAndUpdateVC else { return }
        // CreateAndUpdateVCから遷移してきた時
//        vc.taskSubjectObservable
//            .subscribe(onNext: { [self] task in
//                // numOfSelectedCellが整数（Optionalではない）かどうか
//                if let indexPathRow = numOfSelectedCell {
//                    // 初期化
//                    numOfSelectedCell = nil
//                    // tasksに更新データ（task）を追加
//                    // BehaviorRelay内の値は更新できないので、一時変数を経由して、更新データを代入
//                    var tasksArray = tasks.value
//                    tasksArray[indexPathRow] = task
//                    tasks.accept(tasksArray)
//                } else {
//                    // tasksに新規データ（task）を追加
//                    tasks.accept(tasks.value + [task])
//                }
//                // Realmにテスト用データを追加
//                let viewModel = ViewModel()
//                viewModel.addToRealm(value: tasks.value)
//                tableView.reloadData()
//            }).disposed(by: disposeBag)
    }
}
