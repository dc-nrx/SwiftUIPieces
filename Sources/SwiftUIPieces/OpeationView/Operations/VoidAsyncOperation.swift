//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.01.2024.
//

import Foundation

final public class VoidAsyncOperation: AsyncOperation<Void, Void> {
    
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
