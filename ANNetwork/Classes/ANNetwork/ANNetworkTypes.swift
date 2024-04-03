//
//  ANNetworkTypes.swift
//  ANNetwork
//
//  Created by Ackerman on 2019/5/22.
//

import UIKit
import Result
import Moya

public typealias MoyaResult = Result<Moya.Response, MoyaError>

extension String: Error {}

public enum XBNetworkResult {
    case success([String: Any])
    case error(String)
}

public protocol ANTargetType : TargetType {
    var parameters: [String : Any]? { get }
    var dataKey: String? { get }
}

public extension ANTargetType {
    var parameters: [String : Any]? {
        return nil
    }
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var dataKey: String? {
        return nil
    }
}

public extension MultiTarget {
    var parameters: [String : Any]? {
        if let target = target as? ANTargetType {
            return target.parameters
        }else {
            return nil
        }
    }
}

internal extension MoyaError {
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    var logDescription: String {
        var message = ""
        if let url = response?.response?.url {
            message.append("url: \(url), ")
        }
        if let response = response {
            message.append("status: \(response.debugDescription),")
        }
        if let reason = errorDescription {
            message.append("reason: \(reason)")
        }
        return format("Moya_Logger", date: date, identifier: "ResponseError", message: message)
    }
    
    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }
}
