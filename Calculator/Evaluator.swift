//
//  Evaluator.swift
//  Calculator
//
//  Created by Wang, Michael on 12/7/25.
//

import SwiftUI
import Foundation

enum Operator : String, Hashable{
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case Exponentiate = "^"
    
    public var precedence: Int {
        switch self {
        case .Add, .Subtract: return 1
        case .Multiply, .Divide: return 2
        case .Exponentiate: return 3
        }
    }
}

enum Token : Hashable {
    case NumberToken(Double)
    case OperatorToken(Operator)
    case OpenParenthesis
    case CloseParenthesis
    case Answer
    
    public var asString: String {
        switch self {
        case .NumberToken(let value):
            return String(format: "%g", value)
        case .OperatorToken(let op):
            return op.rawValue
        case .OpenParenthesis: return "("
        case .CloseParenthesis: return ")"
        case .Answer: return "Ans"
        }
    }
}

enum EvaluationError : Error {
    case UnexpectedToken(Token?)
    case DivisionByZero(Double)
    case NoAnswerAvailable
}

final class Scanner {
    private let tokens: [Token]
    private var currentTokenIndex: Int
    
    init(tokens: [Token]) {
        self.tokens = tokens
        self.currentTokenIndex = 0
    }
    
    func scan() -> Token? {
        if currentTokenIndex >= tokens.count {
            return nil
        }
        defer {
            currentTokenIndex += 1
        }
        return tokens[currentTokenIndex]
    }
    
    public var currentToken: Token? {
        if currentTokenIndex >= tokens.count {
            return nil
        }
        return tokens[currentTokenIndex]
    }
}

struct HistoryEntry {
    public let inputTokens: [Token]
    public let result: Double
}

@Observable
final class Evaluator {
    public var history: [HistoryEntry] = []
    
    private let operatorEvaluators: [Operator: (Double, Double) throws -> Double] = [
        .Add: (+),
        .Subtract: (-),
        .Multiply: (*),
        .Divide: {
            guard $1 != 0 else {
                throw EvaluationError.DivisionByZero($0)
            }
            return $0 / $1
        },
        .Exponentiate: pow
    ]
    
    public func evaluate(tokens: [Token]) throws -> Double {
        let scanner = Scanner(tokens: tokens)
        
        func evaluateValue() throws -> Double {
            MetricLogger.shared.start(name: "evaluateValue")
            defer {
                MetricLogger.shared.stop(name: "evaluateValue")
            }
            
            guard let token = scanner.scan() else {
                throw EvaluationError.UnexpectedToken(nil)
            }
            
            switch token {
            case .OpenParenthesis:
                let innerExpr = try evaluateExpression()
         
                guard scanner.currentToken == .CloseParenthesis else {
                    throw EvaluationError.UnexpectedToken(scanner.currentToken)
                }
                
                _ = scanner.scan()
                return innerExpr
            case .NumberToken(let number):
                return number
            case .Answer:
                guard let lastResult = history.last?.result else {
                    throw EvaluationError.NoAnswerAvailable
                }
                
                return lastResult
            default:
                throw EvaluationError.UnexpectedToken(token)
            }
        }
        
        func evaluateExpression(minPrecedence: Int = 0) throws -> Double {
            var lhs = try evaluateValue()
            
            while case .OperatorToken(let operatorType) = scanner.currentToken {
                guard operatorType.precedence >= minPrecedence else {
                    return lhs
                }
                _ = scanner.scan()
                
                let rhs = try evaluateExpression(minPrecedence: operatorType.precedence)
                
                lhs = try operatorEvaluators[operatorType]!(lhs, rhs)
            }
            return lhs
        }
        
        MetricLogger.shared.start(name: "evaluate")
        defer {
            MetricLogger.shared.stop(name: "evaluate")
        }
        
        let answer = try evaluateExpression()
        history.append(HistoryEntry(inputTokens: tokens, result: answer))
        return answer
    }
}
