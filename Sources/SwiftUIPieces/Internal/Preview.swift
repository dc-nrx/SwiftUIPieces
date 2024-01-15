//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import Foundation

class Preview {
    
    static let inputOpVM = makeInputOpVM()
    
    static func makeInputOpVM() -> InputOperation<String> {
        .init { text in
            try! await Task.sleep(for: .seconds(1))
            if Bool.random() {
                throw NSError()
            } else {
                print("whoa! the text is: \(text)")
            }
        }
    }
    
//    static func makeVoidOpVM() -> InputOperation<String> {
//        InputOperation { text in
//            try! await Task.sleep(for: .seconds(1))
//            if Bool.random() || Bool.random() {
//                throw NSError()
//            } else {
//                print("whoa! the text is: \(text)")
//            }
//        }
//    }

}
