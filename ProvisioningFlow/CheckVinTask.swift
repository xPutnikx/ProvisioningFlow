//
//  CheckVinTask.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/17/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


class CheckVinTask: FlowObservableTask {
    typealias ParamType = Void
    typealias ResultType = String
    
    func provideViewControllerNibName() -> String{
        return "CheckVinViewController"
    }
    
    func createFlowController(nibName:String, _ param: Void, _ subscriber: AnyObserver<String>) -> FlowViewController<Void, String>{
        return CheckVinViewController(nibName: nibName, param: param, subscriber: subscriber)
    }
}

class CheckVinViewController: FlowViewController<Void, String> {
    private var vinTextField: UITextField?
    
    func nextButtonPressed(_ sender: Any) {
        if(self.vinTextField != nil && self.vinTextField!.text != nil){
            self.onFinish(data: self.vinTextField!.text!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        if(indexPath.row == 1){
            let cell: CellWithButton = Bundle.main.loadNibNamed("CellWithButton", owner: nil, options: nil)![0] as! CellWithButton
            cell.button.setTitle("Next", for: .normal)
            cell.button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell: CellWithEditText = Bundle.main.loadNibNamed("CellWithEditText", owner: nil, options: nil)![0] as! CellWithEditText
            self.vinTextField = cell.editText
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1){
            self.nextButtonPressed(tableView)
        }
    }
}
