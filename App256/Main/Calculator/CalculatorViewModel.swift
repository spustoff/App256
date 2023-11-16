//
//  CalculatorViewModel.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

final class CalculatorViewModel: ObservableObject {
    
    @Published var selectedCurrency: String = ""
    @Published var amountChange: Float = 0.0
}
