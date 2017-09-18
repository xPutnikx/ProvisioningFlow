//
//  FlowObservableTask.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/16/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation
import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

protocol ViewControllerNameProvider {
    func provideViewControllerNibName() -> String
}

protocol FlowObservableTask: ViewControllerNameProvider {
    associatedtype ParamType
    associatedtype ResultType
    
    func buildObservable(viewController: UINavigationController, param: ParamType) -> Observable<ResultType>
    
    func createFlowController(nibName:String, _ param: ParamType, _ subscriber: AnyObserver<ResultType>) -> FlowViewController<ParamType, ResultType>
}

extension FlowObservableTask {
    
    func buildObservable(viewController: UINavigationController, param: ParamType) -> Observable<ResultType>{
        return Observable<ResultType>.deferred {
            return Observable<ResultType>.create { subscriber in
                let nibName = self.provideViewControllerNibName()
                let flowController = self.createFlowController(nibName: nibName, param, subscriber)
                flowController.presentIn(viewController: viewController)
                return Disposables.create {
                    flowController.dismiss(animated: false) //in theory we need to dismiss it
                }
            }
        }
    }
}

class FlowViewController<ParamType, ResultType>: UITableViewController {
    let param: ParamType
    let subscriber: AnyObserver<ResultType>
    
    init(nibName: String, param: ParamType, subscriber: AnyObserver<ResultType>) {
        self.param = param
        self.subscriber = subscriber
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentIn(viewController: UINavigationController) {
        viewController.pushViewController(self, animated: true)
    }
    
    func onFinish(data: ResultType) {
        self.subscriber.onNext(data)
    }
    
    func onError(error: Error) {
        self.subscriber.onError(error)
    }
}
