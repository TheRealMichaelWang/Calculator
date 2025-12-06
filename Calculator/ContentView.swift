//
//  ContentView.swift
//  Calculator
//
//  Created by Wang, Michael on 12/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var expressionInput: String = ""
    
    private let arithmeticButtons = ["+", "-", "*", "/"]
    private let numberButtons = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    private let numberColumns = 3
    
    var body: some View {
        let gridRows = numberButtons.count / numberColumns
        
        return VStack {
            //text field for expression input
            TextField("69 * 42 + 67", text: $expressionInput)
                .fontWeight(.bold)
                .textInputAutocapitalization(.never)
                .foregroundColor(.black)
                .padding()
            
            //hstack for different types of buttons
            HStack {
                Grid {
                    ForEach(0..<gridRows, id: \.self) { rowIndex in
                        GridRow {
                            ForEach (0..<numberColumns, id: \.self) { colIndex in
                                let index = rowIndex * numberColumns + colIndex
                                let identifier = String(numberButtons[index])
                                
                                Button {
                                    expressionInput += identifier
                                } label: {
                                    Text(identifier)
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    ForEach(0..<arithmeticButtons.count, id: \.self) { rowIndex in
                        Button {
                            expressionInput += " " + arithmeticButtons[rowIndex]
                        } label: {
                            Text(arithmeticButtons[rowIndex])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
