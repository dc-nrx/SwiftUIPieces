//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.01.2024.
//

import Foundation

final public class VoidOperation: AbstractOperation<Void, Void> {
    
    public init(
        _ operation: @escaping Function,
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

public typealias InputOperation<Input> = InoutOperation<Input, Void>

final public class InoutOperation<Input, Output>: AbstractOperation<Input, Output> {

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
        operation: @escaping Function,
        validate: Validator?
    ) {
        self.input = input
        self.validate = validate
        super.init(operation)
    }
}

public extension InoutOperation where Input == String {

    convenience init(
        operation: @escaping Function,
        validate: Validator? = { $0.isEmpty ? "Must not be empty" : nil }
    ) {
        self.init("", operation: operation, validate: validate)
    }

}
