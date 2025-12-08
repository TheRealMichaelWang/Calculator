//
//  PerformanceTests.swift
//  CalculatorTests
//
//  Created by Wang, Michael on 12/8/25.
//

import Foundation
import XCTest
import Calculator

final class EvaluatorPerformanceTests: XCTestCase {
    func testEvaluator() throws {
        let evaluator = Evaluator()
        let inputTokens: [Token] = [
            .NumberToken(10), .OperatorToken(.Add), .NumberToken(20), .OperatorToken(.Multiply),
            .OpenParenthesis, .NumberToken(2), .OperatorToken(.Add), .NumberToken(10), .CloseParenthesis
        ]
        
        self.measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            do {
                _ = try evaluator.evaluate(tokens: inputTokens)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
}
