//
//  RisksView.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct RisksView: View {
    
    @StateObject var viewModel = SignalsViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Risks")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                
                VStack(alignment: .leading, spacing: 20, content: {
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("Trade risk analysis")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Find out what the risks of signal")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.system(size: 13, weight: .regular))
                    })
                    
                    Button(action: {
                        
                        viewModel.isRisks = true
                        
                    }, label: {
                        
                        HStack {
                            
                            Image(systemName: "eye")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                            
                            Text("Find out")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                    })
                })
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack {
                        
                        ForEach(viewModel.signals.filter{viewModel.risks_signals.contains($0.resultDate)}, id: \.self) { index in
                            
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 8, content: {
                                    
                                    Text(index.resultInstrument)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .medium))
                                    
                                    HStack {
                                        
                                        HStack(spacing: 6, content: {
                                            
                                            Text("S/I")
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .medium))
                                            
                                            Text("\(index.resultSl)")
                                                .foregroundColor(.red)
                                                .font(.system(size: 14, weight: .medium))
                                        })
                                        
                                        HStack(spacing: 6, content: {
                                            
                                            Text("T/P")
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .medium))
                                            
                                            Text("\(index.resultTp)")
                                                .foregroundColor(.green)
                                                .font(.system(size: 14, weight: .medium))
                                        })
                                    }
                                    
                                    Text(index.resultDate)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13, weight: .regular))
                                })
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 8, content: {
                                    
                                    Button(action: {
                                        
                                        if viewModel.saved_signals.contains(index.resultDate) {
                                            
                                            if let indexer = viewModel.saved_signals.firstIndex(of: index.resultDate) {
                                                
                                                viewModel.saved_signals.remove(at: indexer)
                                                
                                            }
                                            
                                        } else {
                                            
                                            viewModel.saved_signals.append(index.resultDate)
                                        }
                                        
                                    }, label: {
                                        
                                        Image(systemName: viewModel.saved_signals.contains(index.resultDate) ? "heart.fill" : "heart")
                                            .foregroundColor(Color("primary"))
                                            .font(.system(size: 19, weight: .medium))
                                    })
                                    
                                    Text("$\(String(format: "%.2f", index.resultP))")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .medium))
                                    
                                    Text("Down")
                                        .foregroundColor(.red)
                                        .font(.system(size: 13, weight: .regular))
                                })
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .sheet(isPresented: $viewModel.isRisks, content: {
            
            SelectSignal(risks_signals: $viewModel.risks_signals, selectedSignal: .constant(SignalsItem(resultHash: "", resultInstrument: "", resultPeriod: "", resultTp: 0, resultSl: 0, resultP: 0, resultSignal: "", resultDate: "")))
        })
        .onAppear {
            
            viewModel.getSignals()
        }
    }
}

#Preview {
    RisksView()
}
