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

protocol FlowOrchestrator {
    associatedtype FlowDataModel
  
    func createFlowObservable() -> Observable<FlowDataModel>
}
