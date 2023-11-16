//
//  SignalsAdd.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct SignalsAdd: View {
    
    @Environment(\.presentationMode) var router
    
    @StateObject var viewModel: SignalsViewModel
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    Text("New signal")
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVStack {
                        
                        ZStack(alignment: .leading, content: {
                            
                            Text("Name")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .regular))
                                .opacity(viewModel.name.isEmpty ? 1 : 0)
                            
                            TextField("", text: $viewModel.name)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                        })
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                        
                        HStack {
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Buy")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                                    .opacity(viewModel.buy.isEmpty ? 1 : 0)
                                
                                TextField("", text: $viewModel.buy)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .regular))
                                    .keyboardType(.decimalPad)
                            })
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                            
                            ZStack(alignment: .leading, content: {
                                
                                Text("Sell")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                                    .opacity(viewModel.sell.isEmpty ? 1 : 0)
                                
                                TextField("", text: $viewModel.sell)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .regular))
                                    .keyboardType(.decimalPad)
                            })
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                        }
                        
                        ZStack(alignment: .leading, content: {
                            
                            Text("Stop Loss")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .regular))
                                .opacity(viewModel.stop_loss.isEmpty ? 1 : 0)
                            
                            TextField("", text: $viewModel.stop_loss)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .keyboardType(.decimalPad)
                        })
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                        
                        ZStack(alignment: .leading, content: {
                            
                            Text("Take Profit")
                                .foregroundColor(.gray)
                                .font(.system(size: 14, weight: .regular))
                                .opacity(viewModel.take_profit.isEmpty ? 1 : 0)
                            
                            TextField("", text: $viewModel.take_profit)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .keyboardType(.decimalPad)
                        })
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                        
                        HStack {
                            
                            ForEach(viewModel.durations, id: \.self) { index in
                            
                                Button(action: {
                                    
                                    viewModel.duration = index
                                    
                                }, label: {
                                    
                                    Text(index)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .regular))
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity)
                                        .background(RoundedRectangle(cornerRadius: 5).fill(viewModel.duration == index ? Color("primary") : .gray.opacity(0.2)))
                                })
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    
                    viewModel.addSignal {
                        
                        viewModel.name = ""
                        viewModel.buy = ""
                        viewModel.sell = ""
                        viewModel.stop_loss = ""
                        viewModel.take_profit = ""
                        viewModel.duration = ""
                        
                        viewModel.fetchCoreSignals()
                        
                        router.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    
                    Text("Save")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                        .padding()
                })
                .opacity(viewModel.name.isEmpty || viewModel.buy.isEmpty || viewModel.sell.isEmpty || viewModel.stop_loss.isEmpty || viewModel.take_profit.isEmpty || viewModel.duration.isEmpty ? 0.5 : 1)
                .disabled(viewModel.name.isEmpty || viewModel.buy.isEmpty || viewModel.sell.isEmpty || viewModel.stop_loss.isEmpty || viewModel.take_profit.isEmpty || viewModel.duration.isEmpty ? true : false)
            }
        }
    }
}

#Preview {
    SignalsAdd(viewModel: SignalsViewModel())
}
