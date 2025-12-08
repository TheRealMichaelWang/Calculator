//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Wang, Michael on 12/6/25.
//

import SwiftUI

@main
struct CalculatorApp: App {
    init() {
        AppMetrics.shared.receiveReports()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
