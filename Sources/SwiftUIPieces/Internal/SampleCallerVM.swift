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
    var addVM: InputOperation<String>?
    
    @Published
    var voidVM: VoidOperation?
    
    @Published
    var title: String = ""
    
    init() {
        subscribeToTitleUpdates()
        $addVM.nullifyOnFinish()
        $voidVM.nullifyOnFinish()
    }
    
    func onAdd() {
        addVM = Preview.makeInputOpVM()
    }
    
    func onVoid() {
        voidVM = .init { try await Task.sleep(for: .seconds(2.5)) }
    }
}

private extension SampleCallerVM {

    func subscribeToTitleUpdates() {
        $addVM
            .flatMap { newVM in
                if let newVM {
                    newVM.$state
                        .map(self.title(for:))
                        .eraseToAnyPublisher()
                } else {
                    Just(self.title(for: nil))
                        .eraseToAnyPublisher()
                }
            }
            .assign(to: &$title)
        
        $voidVM
            .flatMap { newVM in
                if let newVM {
                    newVM.$state
                        .map(self.title(for:))
                        .eraseToAnyPublisher()
                } else {
                    Just(self.title(for: nil))
                        .eraseToAnyPublisher()
                }
            }
            .assign(to: &$title)

    }
    
    private func title(for opState: OperationState<Void>?) -> String {
        switch opState {
        case nil: "No op requested"
        case .initial, .canceled: "Waiting for input"
        case .success: "Done"
        case .inProgress: "Runnin'"
        case .operationFailed(let reason): "Failed cause of \(reason)"
        case .validationError(let message): "validation: \(message)"
        }
    }

}
