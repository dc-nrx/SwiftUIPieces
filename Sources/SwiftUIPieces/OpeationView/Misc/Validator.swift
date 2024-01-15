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

