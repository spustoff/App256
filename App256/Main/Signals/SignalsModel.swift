//
//  SignalsModel.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct SignalsModel: Codable, Hashable {
    
    var results: [SignalsItem]
}

struct SignalsItem: Codable, Hashable {
    
    var resultHash, resultInstrument, resultPeriod: String
    
    var resultTp, resultSl, resultP: Double
    
    var resultSignal, resultDate: String
}
