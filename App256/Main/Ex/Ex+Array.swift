//
//  Ex+Array.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

extension Array: RawRepresentable where Element: Codable {
    
    public init?(rawValue: String) {
        
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
                
        else {
            
            return nil
        }
        
        self = result
    }

    public var rawValue: String {
        
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
                
        else {
            
            return "[]"
        }
        
        return result
    }
}


