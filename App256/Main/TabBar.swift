//
//  TabBar.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        
        HStack {
            
            ForEach(Tab.allCases, id: \.self) { index in
                
                Button(action: {
                    
                    selectedTab = index
                    
                }, label: {
                    
                    VStack(alignment: .center, spacing: 10, content: {
                        
                        Image(index.rawValue)
                            .renderingMode(.template)
                            .foregroundColor(selectedTab == index ? Color("primary") : Color.gray)
                            .frame(width: 22, height: 22)
                        
                        Text(index.rawValue)
                            .foregroundColor(selectedTab == index ? Color("primary") : Color.gray)
                            .font(.system(size: 14, weight: .regular))
                    })
                    .frame(maxWidth: .infinity)
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 20)
        .padding(.bottom, 26)
        .background(Color("bg"))
    }
}

enum Tab: String, CaseIterable {
    
    case Signals = "Signals"
    
    case Risks = "Risks"
    
    case Comparison = "Comparison"
    
    case Calculator = "Calculator"
    
}

#Preview {
    ContentView()
}



