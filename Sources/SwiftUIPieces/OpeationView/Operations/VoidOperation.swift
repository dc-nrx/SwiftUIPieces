//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.01.2024.
//

import Foundation

final public class VoidOperation: Operation<Void, Void> {
    
    public init(
        _ function: Function,
        execOnInit: Bool = true
    ) {
        super.init(function)
        if execOnInit {
            Task { await execute() }
        }
    }
    
    public convenience init(
        _ f: @escaping Function.Sync,
        execOnInit: Bool = true
    ) {
        self.init(.sync(f), execOnInit: execOnInit)
    }

    public convenience init(
        _ f: @escaping Function.Async,
        execOnInit: Bool = true
    ) {
        self.init(.async(f), execOnInit: execOnInit)
    }

    @MainActor public func execute() {
        execute(())
    }
}
