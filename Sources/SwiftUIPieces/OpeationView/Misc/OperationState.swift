//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.01.2024.
//

import Foundation
import Combine
//
//public protocol OperationStatePublisherOwner {
//    var operationStatePublisher: Published<OperationStateProtocol> { get set }
//}
//
//public protocol OperationStateProtocol {
//    var isSuccess: Bool { get }
//    var interactionEnabled: Bool { get }
//    var isFinal: Bool { get }
//}

public enum OperationState<Output> {
    
    case initial
    case inProgress(Task<Void, Never>)
    case success(Output)
    case validationError(String)
    case operationFailed(String)
    case canceled
    
    public var isSuccess: Bool {
        if case .success = self { return true }
        else { return false }
    }
    
    public var interactionEnabled: Bool {
        switch self {
        case .success, .canceled, .inProgress: false
        case .initial, .validationError, .operationFailed: true
        }
    }
    
    public var isFinal: Bool {
        switch self {
        case .canceled, .success: true
        default: false
        }
    }
    
    public var str: String {
        return "\(self)"
    }
}
