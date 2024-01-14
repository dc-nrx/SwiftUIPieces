//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import Foundation
import OSLog
import Combine

public enum OperationState<Output> {
    
    case initial
    case inProgress(Task<Void, Never>)
    case success(Output)
    case validationError(String)
    case operationFailed(String)
    case canceled

    public var interactionEnabled: Bool {
        switch self {
        case .success, .canceled, .inProgress: false
        case .initial, .validationError, .operationFailed: true
        }
    }
    
    public var timeToHide: Bool {
        switch self {
        case .canceled, .success: true
        default: false
        }
    }
    
    public var str: String {
        return "\(self)"
    }
}


final class VoidOperation: OperationVM<Void, Void> {
    
    @MainActor
    public func execute() {
        execute(())
    }
}

public typealias InputOperationVM<Input> = InoutOperationVM<Input, Void>

final public class InoutOperationVM<Input, Output>: OperationVM<Input, Output> {

    @Published public var input: Input

    public typealias Validator = (Input) -> String?
    public var validate: Validator? = nil

    @MainActor
    public func execute() {
        if let validationErrorReason = validate?(input) {
            state = .validationError(validationErrorReason)
            return
        }
        
        super.execute(input)
    }
    
    public init(
        _ input: Input,
        operation: @escaping Operation,
        validate: Validator?
    ) {
        self.input = input
        self.validate = validate
        super.init(operation)
    }
}

/**
 An abstract superclass
 */
public class OperationVM<Input, Output>: ObservableObject, Identifiable {
	
    public let id = UUID().uuidString
    
	public typealias Operation = (Input) async throws -> Output
	
	@Published @MainActor
    public var state: OperationState<Output> = .initial
    	
	public let operation: Operation
	
    private var cancellables = Set<AnyCancellable>()
    lazy private var logger = Logger(subsystem: "SwiftUIPieces", category: "\(type(of: self))")
    
	internal init(_ operation: @escaping Operation) {
		self.operation = operation
        
        setupLogging()
	}
	
    @MainActor
	public func cancel() {
        // For `inProgress` flow, the state will eventually become either `cancelled`
        // if cancellation happened, or one of `finished` (success/fail) otherwise.
        if case let .inProgress(task) = state { task.cancel() }
        else { state = .canceled }
	}
	
    @MainActor
    func execute(_ input: Input) {
        let task = Task {
            do {
                let result = try await operation(input)
                state = .success(result)
            } catch {
                if error is CancellationError { state = .canceled }
                else { state = .operationFailed("Smth went wrong"/*error.localizedDescription*/) }
            }
        }
        state = .inProgress(task)
    }
}

private extension OperationVM {
    
    func setupLogging() {
        $state.sink { [weak self] newState in
            let message = "State changed to [\(newState)]"
            self?.logger.debug("\(message)")
            print(message)
        }
        .store(in: &cancellables)
    }
}

public extension InoutOperationVM where Input == String {

    convenience init(
        operation: @escaping Operation,
        validate: Validator? = { $0.isEmpty ? "Must not be empty" : nil }
    ) {
        self.init("", operation: operation, validate: validate)
    }

}
