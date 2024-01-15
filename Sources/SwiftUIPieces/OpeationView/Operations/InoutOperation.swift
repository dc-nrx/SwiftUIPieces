//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.01.2024.
//

import Foundation

public typealias InputOperation<Input> = InoutOperation<Input, Void>

final public class InoutOperation<Input, Output>: Operation<Input, Output> {

    @Published public var input: Input

    public var validator: Validator<Input>?
    
    public init(
        _ input: Input,
        _ function: Function,
        validator: Validator<Input>?
    ) {
        self.input = input
        self.validator = validator
        super.init(function)
    }
    
    public convenience init(
        _ input: Input,
        _ f: @escaping Function.Async,
        validator: Validator<Input>?
    ) {
        self.init(input, .async(f), validator: validator)
    }

    public convenience init(
        _ input: Input,
        _ f: @escaping Function.Sync,
        validator: Validator<Input>?
    ) {
        self.init(input, .sync(f), validator: validator)
    }

    @MainActor
    public func execute() {
        if let validationErrorReason = validator?.check(input) {
            state = .validationError(validationErrorReason)
            return
        }
        super.execute(input)
    }
}

public extension InoutOperation where Input == String {

    convenience init(
        f: @escaping Function.Async,
        validator: Validator<String>? = .nonEmpty()
    ) {
        self.init("", f, validator: validator)
    }

}
