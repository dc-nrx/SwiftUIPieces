//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.01.2024.
//

import Foundation

final public class VoidOperationVM: AbstractOperationVM<Void, Void> {
    
    public init(
        _ operation: @escaping Operation,
        execOnInit: Bool = true
    ) {
        super.init(operation)
        if execOnInit {
            Task { await execute() }
        }
    }

    
    @MainActor public func execute() {
        execute(())
    }
}

public typealias InputOperationVM<Input> = InoutOperationVM<Input, Void>

final public class InoutOperationVM<Input, Output>: AbstractOperationVM<Input, Output> {

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

public extension InoutOperationVM where Input == String {

    convenience init(
        operation: @escaping Operation,
        validate: Validator? = { $0.isEmpty ? "Must not be empty" : nil }
    ) {
        self.init("", operation: operation, validate: validate)
    }

}
