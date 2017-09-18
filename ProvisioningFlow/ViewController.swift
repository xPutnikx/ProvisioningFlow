//
//  ViewController.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/16/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class ViewController: UIViewController {
    var flow: ProvisioningFlow?
    private var bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.flow = ProvisioningFlow(viewController: navigationController!)        
    }

    @IBAction func onPresentPressed(_ sender: Any) {
        let disposable = self.flow?.createFlowObservable().subscribe()
        disposable?.addDisposableTo(bag)
    }
}

