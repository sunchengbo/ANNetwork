//
//  ANError.swift
//  ANNetwork
//
//  Created by Ackerman on 2019/5/22.
//

import UIKit
import Moya

public enum ANError: Error {
    case unknown
    case network(code: Int, description: String)
    case networkDisconnect
    case moya(error: MoyaError)
    case imageUploadFail
    case plain(description: String)
}

extension ANError: LocalizedError {
    
    public var errorNo: Int? {
        switch self {
        case .network(let code, _):
            return code
        default:
            return 999999
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .network(let code, let description):
            switch code {
                // 这里可以根据不同code 选择性的对服务器返回的description做一层包装
            // 目前不对服务器返回的description做任何处理
            default:
                return description
            }
        case .unknown:
            return "未知错误"
            
        case .networkDisconnect:
            return "网络连接失败"
            
        case .moya(let error):
            return error.localizedDescription
            
        case .imageUploadFail:
            return "上传图片失败"
            
        case .plain(let description):
            return description
        }
    }
}

