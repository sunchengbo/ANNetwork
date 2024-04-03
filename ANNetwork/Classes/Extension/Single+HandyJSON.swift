//
//  Single+HandyJSON.swift
//  ANNetwork
//
//  Created by iOS on 2019/5/24.
//

import Foundation
import RxSwift
import HandyJSON

extension PrimitiveSequence where TraitType == SingleTrait, Element == Any {
    
    public func mapObject<T: HandyJSON>(type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            guard let dic = response as? [String: Any] else {
                throw "返回数据不是字典"
            }
            return Single.just(T.deserialize(from: dic)!)
        }
    }
    
    public func mapArray<T: HandyJSON>(type: T.Type) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            guard let array = response as? [Any] else {
                throw "服务器数据不是数组"
            }
            guard let dicts = array as? [[String: Any]] else {
                throw "服务器数据不是字典数组"
            }
            var tempArr = [T]()
            [T].deserialize(from: dicts)?.forEach({ (temp) in
                tempArr.append(temp!)
            })
            return Single.just(tempArr)
        }
    }
}
