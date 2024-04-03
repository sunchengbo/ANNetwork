//
//  UrlStrEncodeExt.swift
//  ANNetwork
//
//  Created by iOS on 2019/5/7.
//

import Foundation

extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    func md5() -> String {
        return MD5(self);
    }
    
    func urlEncode() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = self.startIndex
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = self.index(index, offsetBy: batchSize, limitedBy: self.endIndex) ?? self.endIndex
                let range = startIndex..<endIndex
                
                let substring = self[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    func urlDecode() -> String? {
        return self.removingPercentEncoding
    }
}
