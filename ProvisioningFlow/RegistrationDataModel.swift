//
//  RegistrationDataModel.swift
//  ProvisioningFlow
//
//  Created by Vladimir Hudnitsky on 9/16/17.
//  Copyright © 2017 Vladimir Hudnitsky. All rights reserved.
//

import Foundation

struct ProvisioningDataModel {
    var vin: String?
    var user: AuthenticatedUser?
    var terminalId: String?
}

struct AuthenticatedUser {
    let name: String
    let id: String
}
