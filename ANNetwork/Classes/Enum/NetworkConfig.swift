//
//  NetworkConfig.swift
//  ANNetwork
//
//  Created by Ackerman on 2019/5/23.
//

import UIKit
import ANBaseUI

public extension UserDefaults {
    enum NetworkConfig: String, UserDefaultSettable {
        case an_token = "an_token"
        case an_host = "an_host"
        case an_env = "an_env"
    }
}
