//
//  SignalsView.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct SignalsView: View {
    
    @StateObject var viewModel = SignalsViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                Circle()
                    .fill(Color("primary"))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                
                Circle()
                    .fill(Color.purple)
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: -60, y: -150)
                
                Spacer()
            }
            
            VStack {
                
                ZStack {
                    
                    Text("Signals")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                    
                    HStack {
                        
                        Spacer()
                        
                        NavigationLink(destination: {
                            
                            SignalsFavorites(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                            
                        }, label: {
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .medium))
                        })
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack(spacing: 30) {
                        
                        VStack(alignment: .leading, spacing: 10, content: {
                            
                            Text("My signals")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .regular))
                            
                            VStack(alignment: .leading, spacing: 7, content: {
                                
                                Text("Create your own signal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .regular))
                                
                                Button(action: {
                                    
                                    viewModel.isAdd = true
                                    
                                }, label: {
                                    
                                    Text("Add")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .medium))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                                })
                            })
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("bg")))
                            
                            ForEach(viewModel.coreSignals, id: \.self) { index in
                                
                                HStack {
                                    
                                    VStack(alignment: .leading, spacing: 8, content: {
                                        
                                        Text(index.name ?? "")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15, weight: .medium))
                                        
                                        HStack {
                                            
                                            HStack(spacing: 6, content: {
                                                
                                                Text("S/I")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 14, weight: .medium))
                                                
                                                Text("\(index.stop_loss)")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 14, weight: .medium))
                                            })
                                            
                                            HStack(spacing: 6, content: {
                                                
                                                Text("T/P")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 14, weight: .medium))
                                                
                                                Text("\(index.take_profit)")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 14, weight: .medium))
                                            })
                                        }
                                        
                                        Text("Today")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13, weight: .regular))
                                    })
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 8, content: {
                                        
                                        Text("$\(String(format: "%.2f", index.buy))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 17, weight: .medium))
                                        
                                        Text("Down")
                                            .foregroundColor(.red)
                                            .font(.system(size: 13, weight: .regular))
                                    })
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color("bg")))
                            }
                        })
                        
                        VStack(alignment: .leading, spacing: 10, content: {
                            
                            Text("All signals")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .regular))
                            
                            if viewModel.isLoading {
                                
                                ProgressView()
                                    .padding(.vertical, 100)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
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
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 100)
                                    
                                } else {
                                    
                                    ForEach(viewModel.signals.prefix(12), id: \.self) { index in
                                        
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
                                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("bg")))
                                    }
                                }
                            }
                        })
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $viewModel.isAdd, content: {
            
            SignalsAdd(viewModel: viewModel)
        })
        .onAppear {
         
            viewModel.fetchCoreSignals()
            viewModel.getSignals()
        }
    }
}

#Preview {
    SignalsView()
}
