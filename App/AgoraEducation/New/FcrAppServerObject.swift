//
//  FcrAppServerObject.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

protocol FcrAppCodable: Codable {
    
}

extension FcrAppCodable {
    public static func decode(from json: [String : Any]) throws -> Self  {
        guard JSONSerialization.isValidJSONObject(json) else {
            throw FcrAppError(code: -1,
                              message: "json: \(json) is invalid")
        }
        
        let data = try JSONSerialization.data(withJSONObject: json,
                                              options: [])
        
        let model = try JSONDecoder().decode(Self.self,
                                             from: data)
        
        return model
    }
}

struct FcrAppServerUserInfoObject: FcrAppCodable {
    var companyId: String
    var companyName: String
    var displayName: String
}

struct FcrAppServerResponseObject {
    var code: Int
    var msg: String
    var data: Any
    
    init(json: [String: Any]) throws {
        if let code = json["code"] as? Int {
            self.code = code
        } else {
            throw FcrAppError(code: -1,
                              message: "response's code nil")
        }
        
        if let msg = json["msg"] as? String {
            self.msg = msg
        } else {
            throw FcrAppError(code: -1,
                              message: "response's msg nil")
        }
        
        if let data = json["data"] {
            self.data = data
        } else {
            throw FcrAppError(code: -1,
                              message: "response's data nil")
        }
    }
    
    func dataConvert<T: Any>(type: T.Type) throws -> T {
        if let `data` = data as? T {
            return data
        } else {
            throw FcrAppError(code: -1,
                              message: "Failed data type conversion")
        }
    }
}

