//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import Foundation
import Combine

public extension Published<OperationVM<String, Void>?>.Publisher {
    mutating func nullifyOnFinish() {
        compactMap { $0 }
            .flatMap(\.$state)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .filter(\.timeToHide)
            .map { _ in nil }
            .assign(to: &self)
    }
}

public extension Published<OperationVM<Void, Void>?>.Publisher {
    mutating func nullifyOnFinish() {
        compactMap { $0 }
            .flatMap(\.$state)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .filter(\.timeToHide)
            .map { _ in nil }
            .assign(to: &self)
    }
}
