//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import Foundation

class Preview {
    
    static let operationVM = makeOperationVM()
    
    static func makeOperationVM() -> OperationVM<String, Void> {
        OperationVM(title: "Sample") { text in
            try! await Task.sleep(for: .seconds(1))
            if Bool.random() || Bool.random() {
                throw NSError()
            } else {
                print("whoa! the text is: \(text)")
            }
        }
    }
}
