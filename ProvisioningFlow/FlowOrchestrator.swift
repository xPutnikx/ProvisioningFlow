//
//  FlowOrchestrator.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/16/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class FlowOrchestrator<FlowDataModel> {
    
    func createFlowObservable() -> Observable<FlowDataModel>{
        fatalError("Subclasses need to implement the `createFlowObservable()` method.")
    }
}

class ProvisioningFlow: FlowOrchestrator<ProvisioningDataModel>{
    let initialData: ProvisioningDataModel
    let viewController: UINavigationController
    
    init(initialData: ProvisioningDataModel = ProvisioningDataModel(vin: nil, user: nil, terminalId: nil),
         viewController: UINavigationController) {
        self.initialData = initialData
        self.viewController = viewController
    }
    
    override func createFlowObservable() -> Observable<ProvisioningDataModel>{
        return Observable<ProvisioningDataModel>.deferred {
            return Observable<ProvisioningDataModel>.create { subscriber in
                subscriber.onNext(self.initialData)
                return Disposables.create()
            }
            .flatMap { data in
                return CheckVinTask()
                    .buildObservable(viewController: self.viewController, param: ())
                    .flatMap { innerData -> Observable<ProvisioningDataModel> in
                        let updatedData = ProvisioningDataModel(vin: innerData, user: data.user, terminalId: data.terminalId)
                        return Observable.just(updatedData)
                    }
            }
            .flatMap { data in
                return RegisterUserTask()
                    .buildObservable(viewController: self.viewController, param: ())
                    .flatMap { innerData -> Observable<ProvisioningDataModel> in
                        let updatedData = ProvisioningDataModel(vin: data.vin, user: innerData, terminalId: data.terminalId)
                        return Observable.just(updatedData)
                }
                
            }
        }
    }
}
