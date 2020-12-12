//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/11.
// RxOptionalを使わない手法

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        // プログレスバー、ゲージ、インジケータ、の制御に必要なオブザーバーを定義
        let loadingObservable = webView.rx.observe(Bool.self, "loading")
            // filterNil:nilなら値を流さず、そうでない場合はunwrapして値を流す
            .filterNil()
            // share:ObservableをCold->Hotに変換
            .share()

        // プログレスバーの表示/非表示
        loadingObservable
            // map:値を生成、次回のメソッドで使用できる
            .map {return !$0}
            // bind:subscribeと同じ処理
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)

        // ステータスバーのアクティビティ表示？
        loadingObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        // NavigationTitleの表示
        loadingObservable
            .map { [weak self] _ in return self?.webView.title }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        // プログレスバーのゲージ制御
        webView.rx.observe(Double.self, "estimatedProgress")
            .filterNil()
            .map { return Float($0) }
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)

        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

}

