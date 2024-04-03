//
//  ANEnvManager.swift
//  ANNetwork
//
//  Created by iOS on 2019/8/7.
//

import UIKit

public var AN_isDebug: Bool {
    get {
        var debug = UserDefaults.NetworkConfig.an_env.storedBool
        #if DEBUG
        #else
        debug = false
        #endif
        return debug
    }
    set {
        UserDefaults.NetworkConfig.an_env.store(value: newValue)
    }
}
