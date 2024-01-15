//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import Foundation
import OSLog
import Combine

public class Operation<Input, Output>: ObservableObject, Identifiable {

    public enum Function {
        public typealias Async = (Input) async throws -> Output
        public typealias Sync = (Input) throws -> Output
        case async(Async)
        case sync(Sync)
    }

    @Published @MainActor
    public var state: OperationState<Output> = .initial

    public let id = UUID()
	public let function: Function
    
    private var cancellables = Set<AnyCancellable>()
    lazy private var logger = Logger(subsystem: "SwiftUIPieces", category: "\(type(of: self))")
    
	public init(
        _ function: Function
    ) {
		self.function = function
        setupLogging()
	}
	
    @MainActor public func cancel() {
        // For `inProgress` flow, the state will eventually become either `cancelled`
        // if cancellation happened, or one of `finished` (success/fail) otherwise.
        if case let .inProgress(task) = state { task.cancel() }
        else { state = .canceled }
	}
	
    @MainActor internal func execute(_ input: Input) {        
        switch function {
        case .sync(let f): execSync(f, input)
        case .async(let f): execAsync(f, input)
        }
    }
}

private extension Operation {
    
    @MainActor private func execSync(_ f: Function.Sync, _ input: Input) {
        do {
            try state = .success(f(input))
        } catch {
            state = .operationFailed("Smth went wrong"/*error.localizedDescription*/)
        }
    }

    @MainActor private func execAsync(_ f: @escaping Function.Async, _ input: Input) {
        state = .inProgress( Task {
            do {
                try await state = .success(f(input))
            } catch {
                if error is CancellationError { state = .canceled }
                else { state = .operationFailed("Smth went wrong"/*error.localizedDescription*/) }
            }
        })
    }

    private func setupLogging() {
        $state.sink { [logger] newState in
            let message = "State changed to [\(newState)]"
            logger.debug("\(message)")
            print(message) // for previews
        }
        .store(in: &cancellables)
    }
}
