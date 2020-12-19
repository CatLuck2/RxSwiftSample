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

    private var disposeBag = DisposeBag()
    // タスクを保持
    private let tasks = BehaviorRelay<[TaskOfRealm]>(value: [])
    private let realm = try! Realm()
    // 選択されたセルの番号
    private var numOfSelectedCell:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Realmのテストデータを取得
        if realm.objects(TasksOfRealm.self).isEmpty == false {
            tasks.accept(Array(realm.objects(TasksOfRealm.self)[0].taskList))
        }

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        // didTapSelectRowAt-セルをタップ時の処理
        // itemSelected時にsubscribe(タップされたら購読)
        tableView.rx.itemSelected
            .subscribe(onNext: { [self] indexPath in
                numOfSelectedCell = indexPath.row
                tableView.deselectRow(at: indexPath, animated: true)
                let vc = CreateAndUpdateVC(nibName: "CreateAndUpdateVC", bundle: nil)
                vc.textOfSelectedCell = tasks.value[indexPath.row].title
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks.value[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Realmのデータを削除
            let viewModel = ViewModel()
            tasks.accept(viewModel.getArrayOfTaskOfRealmAfterDeletedElement(value: tasks.value, indexPathRow: indexPath.row))
            viewModel.addToRealm(value: tasks.value)
            tableView.reloadData()
        }
    }
}

extension SettingsVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let vc = viewController as? CreateAndUpdateVC else { return }
        // CreateAndUpdateVCから遷移してきた時
        vc.taskSubjectObservable
            .subscribe(onNext: { [self] task in
                // numOfSelectedCellが整数（Optionalではない）かどうか
                if let indexPathRow = numOfSelectedCell {
                    // 初期化
                    numOfSelectedCell = nil
                    // tasksに更新データ（task）を追加
                    // BehaviorRelay内の値は更新できないので、一時変数を経由して、更新データを代入
                    var tasksArray = tasks.value
                    tasksArray[indexPathRow] = task
                    tasks.accept(tasksArray)
                } else {
                    // tasksに新規データ（task）を追加
                    tasks.accept(tasks.value + [task])
                }
                // Realmにテスト用データを追加
                let viewModel = ViewModel()
                viewModel.addToRealm(value: tasks.value)
                tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}
