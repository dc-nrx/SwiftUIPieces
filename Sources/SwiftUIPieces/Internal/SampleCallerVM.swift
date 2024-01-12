//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import Foundation
import Combine

@MainActor
class SampleCallerVM: ObservableObject {
    
    @Published
    var addVM: OperationVM<String, Void>?
    
    @Published
    var title: String = ""
    
    init() {
        subscribeToTitleUpdates()
        subscribeToAddVmNullifier()
    }
    
    func onAdd() {
        addVM = Preview.makeOperationVM()
    }
}

private extension SampleCallerVM {
    
    func subscribeToAddVmNullifier() {
        $addVM
            .compactMap { $0 }
            .flatMap(\.$state)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .filter(\.timeToHide)
            .map { _ in nil }
            .assign(to: &$addVM)
    }
    
    func subscribeToTitleUpdates() {
        $addVM
            .flatMap { newVM in
                if let newVM {
                    newVM
                        .$state
                        .map(self.title(for:))
                        .eraseToAnyPublisher()
                } else {
                    Just("No action requested")
                        .eraseToAnyPublisher()
                }
            }
            .assign(to: &$title)
    }
    
    private func title(for opState: OperationState<Void>) -> String {
        switch opState {
        case .initial, .canceled: "Waiting for input"
        case .success: "Done"
        case .inProgress: "Runnin'"
        case .operationFailed(let reason): "Failed cause of \(reason)"
        case .validationError(let message): "validation: \(message)"
        }
    }

}
