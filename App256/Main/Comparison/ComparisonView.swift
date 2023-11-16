//
//  ComparisonView.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct ComparisonView: View {
    
    @StateObject var viewModel = SignalsViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Signal Comparison")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                
                if !viewModel.comparison_first.resultInstrument.isEmpty {
                    
                    let first = viewModel.comparison_first
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            Text(first.resultInstrument)
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                            
                            HStack {
                                
                                HStack(spacing: 6, content: {
                                    
                                    Text("S/I")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(first.resultSl)")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14, weight: .medium))
                                })
                                
                                HStack(spacing: 6, content: {
                                    
                                    Text("T/P")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(first.resultTp)")
                                        .foregroundColor(.green)
                                        .font(.system(size: 14, weight: .medium))
                                })
                            }
                            
                            Text(first.resultDate)
                                .foregroundColor(.gray)
                                .font(.system(size: 13, weight: .regular))
                        })
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8, content: {
                            
                            Button(action: {
                                
                                if viewModel.saved_signals.contains(first.resultDate) {
                                    
                                    if let indexer = viewModel.saved_signals.firstIndex(of: first.resultDate) {
                                        
                                        viewModel.saved_signals.remove(at: indexer)
                                        
                                    }
                                    
                                } else {
                                    
                                    viewModel.saved_signals.append(first.resultDate)
                                }
                                
                            }, label: {
                                
                                Image(systemName: viewModel.saved_signals.contains(first.resultDate) ? "heart.fill" : "heart")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 19, weight: .medium))
                            })
                            
                            Text("$\(String(format: "%.2f", first.resultP))")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                            
                            Text("Down")
                                .foregroundColor(.red)
                                .font(.system(size: 13, weight: .regular))
                        })
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                    .padding(.horizontal)
                    .onTapGesture {
                        
                        viewModel.selectedComparison = 1
                        viewModel.isComparison = true
                    }
                    
                } else {
                    
                    HStack {
                        
                        Image(systemName: "doc")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 15, weight: .medium))
                            .frame(width: 35, height: 35)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color("bg")))
                        
                        Text("Add a signal")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                        
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary").opacity(0.1)))
                    .padding(.horizontal)
                    .onTapGesture {
                        
                        viewModel.selectedComparison = 1
                        viewModel.isComparison = true
                    }
                }
                
                Image("vector")
                
                if !viewModel.comparison_second.resultInstrument.isEmpty {
                    
                    let second = viewModel.comparison_second
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            Text(second.resultInstrument)
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                            
                            HStack {
                                
                                HStack(spacing: 6, content: {
                                    
                                    Text("S/I")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(second.resultSl)")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14, weight: .medium))
                                })
                                
                                HStack(spacing: 6, content: {
                                    
                                    Text("T/P")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Text("\(second.resultTp)")
                                        .foregroundColor(.green)
                                        .font(.system(size: 14, weight: .medium))
                                })
                            }
                            
                            Text(second.resultDate)
                                .foregroundColor(.gray)
                                .font(.system(size: 13, weight: .regular))
                        })
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8, content: {
                            
                            Button(action: {
                                
                                if viewModel.saved_signals.contains(second.resultDate) {
                                    
                                    if let indexer = viewModel.saved_signals.firstIndex(of: second.resultDate) {
                                        
                                        viewModel.saved_signals.remove(at: indexer)
                                        
                                    }
                                    
                                } else {
                                    
                                    viewModel.saved_signals.append(second.resultDate)
                                }
                                
                            }, label: {
                                
                                Image(systemName: viewModel.saved_signals.contains(second.resultDate) ? "heart.fill" : "heart")
                                    .foregroundColor(Color("primary"))
                                    .font(.system(size: 19, weight: .medium))
                            })
                            
                            Text("$\(String(format: "%.2f", second.resultP))")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .medium))
                            
                            Text("Down")
                                .foregroundColor(.red)
                                .font(.system(size: 13, weight: .regular))
                        })
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                    .padding(.horizontal)
                    .onTapGesture {
                        
                        viewModel.selectedComparison = 2
                        viewModel.isComparison = true
                    }
                    
                } else {
                    
                    HStack {
                        
                        Image(systemName: "doc")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 15, weight: .medium))
                            .frame(width: 35, height: 35)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color("bg")))
                        
                        Text("Add a signal")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .medium))
                        
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color("primary").opacity(0.1)))
                    .padding(.horizontal)
                    .onTapGesture {
                        
                        viewModel.selectedComparison = 2
                        viewModel.isComparison = true
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isComparison, content: {
            
            if viewModel.selectedComparison == 1 {
                
                SelectSignal(risks_signals: .constant([]), selectedSignal: $viewModel.comparison_first)
                
            } else if viewModel.selectedComparison == 2 {
                
                SelectSignal(risks_signals: .constant([]), selectedSignal: $viewModel.comparison_second)
            }
        })
    }
}

#Preview {
    ComparisonView()
}
