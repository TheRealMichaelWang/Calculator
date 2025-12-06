//
//  ContentView.swift
//  Calculator
//
//  Created by Wang, Michael on 12/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var expressionInput: String = ""
        
    // 1. Define the layout as a single 2D array (Rows containing Columns)
    // This allows us to mix numbers and operators in the same row easily.
    private let buttons: [[String]] = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            // 3. Stylized Display
            TextField("0", text: $expressionInput)
                .font(.system(size: 64)) // Make it huge
                .fontWeight(.light)
                .multilineTextAlignment(.trailing) // Align to right
                .padding()
                .foregroundColor(.white)
                .background(Color.black) // Calculator display style
            
            // 4. The Loop
            // We loop through the rows...
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    // ...and then loop through the items in that row
                    ForEach(row, id: \.self) { item in
                        Button {
                            handleButtonPress(item)
                        } label: {
                            Text(item)
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 80, height: 80) // Fixed circle size
                                .background(getBackgroundColor(item)) // Dynamic Color
                                .foregroundColor(.white)
                                .cornerRadius(40) // Makes it a circle
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black) // Dark mode background
    }
    
    // Helper to keep the view clean: Determine Color
    func getBackgroundColor(_ item: String) -> Color {
        switch item {
        case "/", "*", "-", "+", "=":
            return .orange
        case ".", "C":
            return Color(UIColor.lightGray)
        default:
            return Color(UIColor.darkGray)
        }
    }
    
    // Helper to keep logic clean
    func handleButtonPress(_ item: String) {
        if item == "=" {
            // Add your calculation logic here later
        } else {
            expressionInput += item
        }
    }
}

#Preview {
    ContentView()
}
