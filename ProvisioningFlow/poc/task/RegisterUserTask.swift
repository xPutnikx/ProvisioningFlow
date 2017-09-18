//
//  RegisterUserTask.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/18/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class RegisterUserTask: FlowObservableTask{
    typealias ParamType = Void
    typealias ResultType = AuthenticatedUser
    
    func provideViewControllerNibName() -> String {
        return "RegisterUserViewController"
    }
    
    func createFlowController(nibName: String, _ param: Void, _ subscriber: AnyObserver<AuthenticatedUser>) -> FlowViewController<Void, AuthenticatedUser> {
        return RegisterUserViewController(nibName: nibName, param: param, subscriber: subscriber)
    }
}

class RegisterUserViewController: FlowViewController<Void, AuthenticatedUser>{
    private var usernameTextField: UITextField?
    
    func nextButtonPressed(_ sender: Any) {
        if(self.usernameTextField != nil && self.usernameTextField!.text != nil){
            self.onFinish(data: AuthenticatedUser(name: self.usernameTextField!.text!, id: "mock_id"))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 1){
            let cell: CellWithButton = Bundle.main.loadNibNamed("CellWithButton", owner: nil, options: nil)![0] as! CellWithButton
            cell.button.setTitle("Done", for: .normal)
            cell.button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell: CellWithEditText = Bundle.main.loadNibNamed("CellWithEditText", owner: nil, options: nil)![0] as! CellWithEditText
            self.usernameTextField = cell.editText
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1){
            self.nextButtonPressed(tableView)
        }
    }

    
}
