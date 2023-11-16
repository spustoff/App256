//
//  SelectSignal.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct SelectSignal: View {
    
    @StateObject var viewModel = SignalsViewModel()
    
    @Environment(\.presentationMode) var router
    
    @Binding var risks_signals: [String]
    @Binding var selectedSignal: SignalsItem
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("Signal Selection")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    HStack {
                        
                        Button(action: {
                            
                            router.wrappedValue.dismiss()
                            
                        }, label: {
                            
                            HStack {
                                
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .regular))
                                
                                Text("Back")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .regular))
                            }
                        })
                        
                        Spacer()
                    }
                }
                .padding()
                .padding(.top)
                
                if viewModel.isLoading {
                    
                    ProgressView()
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                } else {
                    
                    if viewModel.signals.isEmpty {
                        
                        VStack(alignment: .center, spacing: 4, content: {
                            
                            Text("No any signals")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                                .multilineTextAlignment(.center)
                            
                            Text("We don't have any signal right now")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.center)
                        })
                        .frame(maxHeight: .infinity, alignment: .center)
                        
                    } else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            LazyVStack {
                                
                                ForEach(viewModel.signals.prefix(12), id: \.self) { index in
                                    
                                    Button(action: {
                                        
                                        selectedSignal = index
                                        risks_signals.append(index.resultDate)
                                        
                                        router.wrappedValue.dismiss()
                                        
                                    }, label: {
                                        
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
                                    })
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            
            viewModel.getSignals()
        }
    }
}

//#Preview {
//    SelectSignal(risks_signals: .constant(["fpdsojfsd"]), selectedSignal: .constant())
//}
