//
//  ANNetwork.swift
//  ANNetwork
//
//  Created by iOS on 2019/5/7.
//

import Foundation
import Moya
import RxSwift
import Alamofire

public typealias ANCompletion = (Bool,String) -> Void

/// host 默认host 一般需要
public var AN_HOST: String {
    set {
        // 设置过后存到 userDefault里面 方便测试环境使用
        UserDefaults.NetworkConfig.an_host.store(value: newValue)
    }
    get {
        var host: String = ""
        if let tmpHost = ANNetwork.instance.an_default_host {
            host = tmpHost
        } else {
            assert(true, "please set ANNetwork.instance.an_default_host=xxx for default host")
        }
        if !AN_isDebug { return host } // 如果是release环境 直接设置默认Url为host release环境不允许切换host
        if let tmpHost = UserDefaults.NetworkConfig.an_host.storedString {
            host = tmpHost
        }
        return host
    }
}

public class ANNetwork {
    public static let instance = ANNetwork()
    public var an_default_host: String?
    public var an_token: String?
    public var an_headers:[String: String] = [:]
    
    public static let provider = MoyaProvider<MultiTarget>(endpointClosure: ANNetwork.endpointMapping, callbackQueue: DispatchQueue.main, manager: ANNetwork.alamofireManager(), plugins: [NetworkLoggerPlugin(verbose: true, output: ANNetwork.loggerOutput)])
}

extension ANNetwork {
    
    public final class func loggerOutput(separator: String, terminator: String, items: Any...) -> Void {
        items.compactMap{ $0 }.forEach { print($0) }
    }
    
    public final class func alamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        let manager = Manager(configuration: configuration, serverTrustPolicyManager: CustomServerTrustPoliceManager())
        manager.startRequestsImmediately = false
        return manager
    }
    
    public final class func endpointMapping(for target: MultiTarget) -> Endpoint {
        var headers = target.headers ?? [String: String]()
        headers.merge(self.instance.an_headers) { (_, newValue) in newValue }
        if !headers.keys.contains("token") {
            headers["token"] = self.instance.an_token
        }
        
        let params: [String : Any] = target.parameters ?? [:]
        var url = URL(target: target).absoluteString
        url = "\(AN_HOST)\(target.path)"
        //        switch target.method {
        //        case .get: // host/path?params
        //
        //        case .post:
        //            let result = packagePostRequestUrl(path: target.path, params: params)
        //            url     = result.url
        //        case .put:
        //            let result = packagePutRequestUrl(path: target.path, params: params)
        //            url     = result.url
        //            ts      = result.ts
        //            sign    = result.sign
        //        case .delete:
        //            let result = packageDeleteRequestUrl(path: target.path, params: params)
        //            url     = result.url
        //        default:
        //            break
        //        }
        
        let task: Task
        
        switch target.task {
        case .requestPlain:
            task = .requestParameters(parameters: params, encoding: URLEncoding())
        default:
            task = target.task
        }
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: task,
            httpHeaderFields: headers
        )
    }
    
    public final class func defaultCompletion(result: MoyaResult,dataKey: String = "data") throws -> Any {
        switch result {
        case let .success(response):
            do {
                let str = try response.mapString()
                return str
            } catch let error {
                if error is ANError {
                    throw error
                } else if let moyaError = error as? MoyaError {
                    print("走这里了33333")
                    print(moyaError.logDescription)
                    //                    networkLogger.error(moyaError.logDescription)
                    let error: ANError = ANError.moya(error: moyaError)
                    throw error
                } else {
                    let error: ANError = ANError.unknown
                    throw error
                }
            }
        case let .failure(error):
            print("走这里了4444")
            print(error.logDescription)
            //            networkLogger.error(error.logDescription)
            let error: ANError = ANError.networkDisconnect
            throw error
        }
    }
    
    public final class func validateServerCode(responseData: [String: Any]) throws {
        guard let code = responseData["errno"] as? Int else { throw "服务器异常" }
        if code != 0 {
            throw ANError.network(code: code, description: responseData["errmsg"] as! String)
        }
    }
    
}

class CustomServerTrustPoliceManager: ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        //        guard let bundle = currentBundle() else {
        //            return .disableEvaluation
        //        }
        //        let certificates = ServerTrustPolicy.certificates(in: bundle)
        //        if certificates.count > 0 {
        //            return .pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)
        //        }
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}

public func request(target: ANTargetType) -> Single<Any>{
    print("请求数据",target)
    return Single.create { single in
        let cancellableToken = ANNetwork.provider.request(MultiTarget(target)) { result in
            do {
                if let dataKey = target.dataKey {
                    print("走这里了111111")
                    let data = try ANNetwork.defaultCompletion(result: result, dataKey: dataKey)
                    single(.success(data))
                } else {
                    print("走这里了22222")
                    let data = try ANNetwork.defaultCompletion(result: result)
                    single(.success(data))
                }
            } catch let error {
                single(.error(error))
            }
        }
        return Disposables.create {
            cancellableToken.cancel()
        }
    }
}

func currentBundle() -> Bundle? {
    guard let url = Bundle(for: ANNetwork.self).url(forResource: "ANNetwork", withExtension: "bundle") else {
        return nil
    }
    return Bundle(url: url)
}
