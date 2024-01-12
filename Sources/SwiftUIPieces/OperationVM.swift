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
    
    public var str: String {
        return "\(self)"
    }
}

public class OperationVM<Input, Output>: ObservableObject {
	
	public typealias Operation = (Input) async throws -> Output
	public typealias Validator = (Input) -> String?
	
	@Published @MainActor
    public var state: OperationState<Output> = .initial
    
	@Published public var input: Input
	
	public var validate: Validator? = nil

	public let title: String
	public let operation: Operation
	
    private var cancellables = Set<AnyCancellable>()
    lazy private var logger = Logger(subsystem: "SwiftUIPieces", category: "\(type(of: self))")
    
	public init(
        _ input: Input,
		title: String,
		operation: @escaping Operation,
		validate: Validator?
    ) {
		self.title = title
		self.input = input
		self.operation = operation
		self.validate = validate
        
        setupLogging()
	}
	
    @MainActor
	public func onCancel() {
        // For `inProgress` flow, the state will eventually become either `cancelled`
        // if cancellation happened, or one of `finished` (success/fail) otherwise.
        if case let .inProgress(task) = state { task.cancel() }
        else { state = .canceled }
	}
	
    @MainActor 
    public func onSubmit() {
        guard state.interactionEnabled else { return }
        
		if let validationErrorReason = validate?(input) {
			state = .validationError(validationErrorReason)
			return
		}
        
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

public extension OperationVM where Input == String {

    convenience init(
        title: String,
        operation: @escaping Operation,
        validate: Validator? = { $0.isEmpty ? "Must not be empty" : nil }
    ) {
        self.init("", title: title, operation: operation, validate: validate)
    }

}
