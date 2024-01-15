//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.01.2024.
//

import Foundation

public struct Validator<Input> {
    public var check: (Input) -> String?
    
    public static func nonEmpty(
        _ message: String = "Must not be empty"
    ) -> Validator<String> {
        .init { $0.isEmpty ? message : nil }
    }
}

public typealias InputAsyncOperation<Input> = InoutAsyncOperation<Input, Void>

final public class InoutAsyncOperation<Input, Output>: AsyncOperation<Input, Output> {

    @Published public var input: Input

    public var validator: Validator<Input>?
    
    public init(
        _ input: Input,
        operation: @escaping Function,
        validator: Validator<Input>?
    ) {
        self.input = input
        self.validator = validator
        super.init(operation)
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

public extension InoutAsyncOperation where Input == String {

    convenience init(
        operation: @escaping Function,
        validator: Validator<String>? = .nonEmpty()
    ) {
        self.init("", operation: operation, validator: validator)
    }

}
