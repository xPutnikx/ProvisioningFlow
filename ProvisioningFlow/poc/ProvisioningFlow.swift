//
//  ProvisioningFlow.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/18/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif


class ProvisioningFlow: FlowOrchestrator {
  typealias FlowDataModel = ProvisioningDataModel
  
  let initialData: ProvisioningDataModel
  let viewController: UINavigationController
  
  init(initialData: ProvisioningDataModel = ProvisioningDataModel(vin: nil, user: nil, terminalId: nil),
       viewController: UINavigationController) {
    self.initialData = initialData
    self.viewController = viewController
  }
  
  func createFlowObservable() -> Observable<ProvisioningDataModel>{
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
