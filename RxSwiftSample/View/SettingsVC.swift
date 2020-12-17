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
    private let tasks = BehaviorRelay<[Task]>(value: [])
    private let realm = try! Realm()
    private var realmResults:Results<TasksOfRealm>!
    // 選択されたセルの番号
    private var numOfSelectedCell:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Realmのテストデータを取得
        realmResults = realm.objects(TasksOfRealm.self)

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
//                vc.textOfSelectedCell = tasks.value[indexPath.row].title
                vc.textOfSelectedCell = realmResults[0].taskList[indexPath.row].title
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tasks.value.count
        realmResults[0].taskList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = tasks.value[indexPath.row].title
        cell.textLabel?.text = realmResults[0].taskList[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            var tasksArray = tasks.value
//            tasksArray.remove(at: indexPath.row)
//            tasks.accept(tasksArray)
            // Realmのデータを削除
            try! realm.write {
                realmResults[0].taskList.remove(at: indexPath.row)
            }
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
//                    var tasksArray = tasks.value
//                    tasksArray[indexPathRow] = task
//                    tasks.accept(tasksArray)
                    // Realmのデータを更新
                    try! realm.write {
                        realmResults[0].taskList[indexPathRow].title = task.title
                    }
                    tableView.reloadData()
                } else {
//                    // tasksに新規データ（task）を追加
//                    tasks.accept(tasks.value + [task])
                    // Realmにテスト用データを追加
                    if realmResults.isEmpty {
                        var array:[[String:Any]]! = []
                        for task in tasks.value {
                            array.append(["title":task.title])
                        }
                        let testTask = TasksOfRealm(value: ["taskList":array!])
                        try! realm.write {
                            realm.add(testTask, update: .modified)
                        }
                    } else {
                        let taskInstance = TaskOfRealm()
                        taskInstance.title = task.title
                        try! realm.write {
                            realmResults[0].taskList.append(taskInstance)
                        }
                    }
                    tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
}
