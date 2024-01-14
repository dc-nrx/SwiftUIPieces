//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import Foundation
import OSLog
import Combine

public class AbstractOperationVM<Input, Output>: ObservableObject, Identifiable {
	
    public typealias Operation = (Input) async throws -> Output

    @Published @MainActor
    public var state: OperationState<Output> = .initial

    public let id = UUID().uuidString
	public let operation: Operation
    
    private var cancellables = Set<AnyCancellable>()
    lazy private var logger = Logger(subsystem: "SwiftUIPieces", category: "\(type(of: self))")
    
	public init(
        _ operation: @escaping Operation
    ) {
		self.operation = operation
        setupLogging()
	}
	
    @MainActor public func cancel() {
        // For `inProgress` flow, the state will eventually become either `cancelled`
        // if cancellation happened, or one of `finished` (success/fail) otherwise.
        if case let .inProgress(task) = state { task.cancel() }
        else { state = .canceled }
	}
	
    @MainActor internal func execute(_ input: Input) {
        state = .inProgress( Task {
            do {
                let result = try await operation(input)
                state = .success(result)
            } catch {
                if error is CancellationError { state = .canceled }
                else { state = .operationFailed("Smth went wrong"/*error.localizedDescription*/) }
            }
        })
//        state = .inProgress(task)
    }
    
    private func setupLogging() {
        $state.sink { [weak self] newState in
            let message = "State changed to [\(newState)]"
            self?.logger.debug("\(message)")
            print(message)
        }
        .store(in: &cancellables)
    }
}
