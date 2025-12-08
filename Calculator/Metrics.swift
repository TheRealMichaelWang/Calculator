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
        
    }
    
    //receiver for instantaneous reports
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        
    }
}
