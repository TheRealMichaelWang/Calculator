//
//  ContentView.swift
//  Calculator
//
//  Created by Wang, Michael on 12/6/25.
//

import SwiftUI

enum CalculatorButton : Hashable {
    case DigitButton(Int)
    case DecimalButton
    case TokenButton(Token)
    case EnterButton
    case ClearButton
    
    public var label: String {
        switch self {
        case .DigitButton(let digit):
            return String(digit)
        case .DecimalButton: return "."
        case .TokenButton(let token):
            return token.asString
        case .EnterButton: return "="
        case .ClearButton: return "CLR"
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .TokenButton(.OperatorToken(_)):
            return .orange
        case .EnterButton, .ClearButton:
            return Color(UIColor.lightGray)
        default:
            return Color(UIColor.darkGray)
        }
    }
}

struct ContentView: View {
    @State private var inputTokens: [Token] = []
    @State private var numberString: String = ""
    
    // 1. Define the layout as a single 2D array (Rows containing Columns)
    // This allows us to mix numbers and operators in the same row easily.
    private let buttons: [[CalculatorButton]] = [
        [
            .DigitButton(7), .DigitButton(8), .DigitButton(9),
            .TokenButton(.OperatorToken(.Divide))
        ],
        [
            .DigitButton(4), .DigitButton(5), .DigitButton(6),
            .TokenButton(.OperatorToken(.Multiply))
        ],
        [
            .DigitButton(1), .DigitButton(2), .DigitButton(3),
            .TokenButton(.OperatorToken(.Subtract)) // Changed divide to subtract
        ],
        [
            .DigitButton(0), .DecimalButton, .EnterButton,
            .TokenButton(.OperatorToken(.Add)) // Changed divide to add
        ],
        [.ClearButton] // Add a dedicated clear button
    ]
    
    private var displayString: Binding<String> {
        Binding<String>(
            get: {
                // Step 1: Create a simple array of strings
                let stringTokens = inputTokens.map(\.asString)
                // Step 2: Join the array
                let finalString = stringTokens.joined(separator: " ")
                return finalString + numberString
            },
            set: { _ in }
        )
    }

    var body: some View {
        VStack(spacing: 12) {
            // 3. Stylized Display
            TextField("0", text: displayString)
                .minimumScaleFactor(0.25)
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
                    ForEach(row, id: \.self) { button in
                        Button {
                            handleButtonPress(button: button)
                        } label: {
                            Text(button.label)
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 80, height: 80)
                                .background(button.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black) // Dark mode background
    }
    
    func finalizeToken() {
        guard !numberString.isEmpty else { return }
        guard let number = Double(numberString) else { return }
        
        inputTokens.append(.NumberToken(number))
        numberString = ""
    }
    
    // Helper to keep logic clean
    func handleButtonPress(button: CalculatorButton) {
        switch button {
        case .DigitButton(let digit):
            numberString.append(String(digit))
        case .DecimalButton:
            if !numberString.contains(".") {
                numberString.append(".")
            }
        case .ClearButton:
            numberString = ""
            inputTokens = []
        case .TokenButton(let token):
            finalizeToken()
            inputTokens.append(token)
        case .EnterButton:
            finalizeToken()
            
            //evaluate expression with input tokens
            
            inputTokens = []
        }
    }
}

#Preview {
    ContentView()
}
