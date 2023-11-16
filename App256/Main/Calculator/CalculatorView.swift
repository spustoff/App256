//
//  CalculatorView.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct CalculatorView: View {
    
    @StateObject var viewModel = CalculatorViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Calculator")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                
                Menu {
                    
                    ForEach(["EURUSD", "EURTRY", "EURKZT", "EURJPY", "EURCAD", "EURRUB"], id: \.self) { index in
                    
                        Button(action: {
                            
                            viewModel.selectedCurrency = index
                            
                        }, label: {
                            
                            HStack {
                                
                                Text(index)
                                
                                Spacer()
                                
                                if viewModel.selectedCurrency == index {
                                    
                                    Image(systemName: "xmark")
                                }
                            }
                        })
                    }
                    
                } label: {
                    
                    HStack {
                        
                        Image(systemName: "dollarsign")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 15, weight: .medium))
                            .frame(width: 35, height: 35)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color("bg")))
                        
                        Text(viewModel.selectedCurrency.isEmpty ? "Add a currency" : viewModel.selectedCurrency)
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                        
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary").opacity(0.1)))
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 10, content: {
                    
                    Text("Add the amount you want to change")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 14, weight: .regular))
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text(String(format: "%.2f", viewModel.amountChange))
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                        
                        Slider(value: $viewModel.amountChange)
                    })
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary").opacity(0.1)))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15, content: {
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("You have")
                            .foregroundColor(.gray)
                            .font(.system(size: 13, weight: .regular))
                        
                        Text("$\(Int.random(in: 1...5000))")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                    })
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("You'll get")
                            .foregroundColor(.gray)
                            .font(.system(size: 13, weight: .regular))
                        
                        Text("$\(Int.random(in: 1...500000))")
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .semibold))
                    })
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("Currency rate")
                            .foregroundColor(.gray)
                            .font(.system(size: 13, weight: .regular))
                        
                        Text("\(Int.random(in: 1...500000))")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                    })
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    CalculatorView()
}
