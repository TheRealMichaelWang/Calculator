//
//  Metrics.swift
//  Calculator
//
//  Created by Wang, Michael on 12/8/25.
//

import Foundation
import MetricKit

final class AppMetrics : NSObject, MXMetricManagerSubscriber {
    static let shared = AppMetrics()

    func receiveReports() {
        MXMetricManager.shared.add(self)
    }
    
    func pasueReprots() {
        MXMetricManager.shared.remove(self)
    }
    
    //receiver for daily metrics
    func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            do {
                // 1. Get the JSON Data
                let jsonPayload = payload.jsonRepresentation()
                
                // 2. Define a unique file name
                let fileName = "MXPayload_\(Date().timeIntervalSince1970).json"
                
                // 3. Define the path in the Documents directory
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                
                // 4. Write the JSON Data to the file
                try jsonPayload.write(to: fileURL)
            } catch {
                print("Error writing payload JSON file: \(error.localizedDescription)")
            }
        }
    }
    
    //receiver for instantaneous reports
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        
    }
}

struct MetricLogger {
    static let shared = MetricLogger(category: "com.example.Calculator")
    
    private let logger: OSLog
    
    init(category: String) {
        self.logger = MXMetricManager.makeLogHandle(category: category)
    }
    
    func start(name: StaticString) {
        mxSignpost(.begin, log: self.logger, name: name)
    }
    
    func stop(name: StaticString) {
        mxSignpost(.end, log: self.logger, name: name)
    }
}
