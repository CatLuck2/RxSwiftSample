//
//  MyMemo.swift
//  RxSwiftSample
//
//  Created by Nekokichi on 2020/12/12.
//

import Foundation

/*

 ストリーム：ユーザーが行うアクション
 Observable：ストリームで用いられるクラス
 Observable：Observer = ストリーム：Observableを監視するもの

 Dispose(by: DisposeBag())は、deinitされるときに呼ばれ、呼び出し元のObservableを解放してくれる

 シングルトンはdisposeされないので要注意

 Relayは、onErrorとonCompleteが発生しても、購読を継続できる
 Relayは、UIや値の更新を伝えるデータバインディングが得意
 Relayの修飾子はprivateにせよ

 Operator:Observableのイベント値を加工して、新たなObservableを生成する仕組み
 Operatorの種類：変換(map)、絞り込み(filter) 組み合わせ(zip)

 Driver：エラー処理が得意、UI更新で使われる

 */
