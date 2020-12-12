//
//  CounterRxViewModel.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional
import RxWebKit

class ViewControllerByRxWebKit: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        // プログレスバー、ゲージ、インジケータ、の制御に必要なオブザーバーを定義
        // 変わったこと：引数を設定しなくなった
        let loadingObservable = webView.rx.loading
            .share()

        // プログレスバーの表示/非表示
        loadingObservable
            .map {return !$0}
            // observeOn:オブザーバーのスケジューラを指定
            // スケジューラ：スレッド
            // スケジューラには、直列2つ,並列2つ、がある
            // 参考：https://scior.hatenablog.com/entry/2019/07/24/002743#SerialDispatchQueueScheduler
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)

        // ステータスバーのアクティビティ表示？
        loadingObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        // NavigationTitleの表示
        // 変わったこと：map{}が不要に、map{}で参照変数やらを書く必要がなくなった
        webView.rx.title
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        // プログレスバーのゲージ制御
        webView.rx.estimatedProgress
            .map { return Float($0) }
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)

        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

}
