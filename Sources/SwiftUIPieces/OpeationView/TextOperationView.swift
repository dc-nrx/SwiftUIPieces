//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import SwiftUI

public struct TextOperationView<Output>: View {
	
    let title: String
    let placeholder: String
	
    @ObservedObject var vm: OperationVM<String, Output>
	
    @FocusState private var focus: Bool
    
    public init(
        _ title: String,
        placeholder: String = "",
        _ vm: OperationVM<String, Output>
    ) {
        self.vm = vm
        self.title = title
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            Group {
                Text(title)
                    .font(.title)
                TextField(placeholder, text: $vm.input)
                    .focused($focus)
                    .onSubmit { vm.onSubmit() }
                Spacer()
                HStack {
                    Button("Cancel") { vm.onCancel() }
                        .foregroundStyle(.secondary)
                        .bold()
                    Spacer()
                    Button("Confirm") {
                        vm.onSubmit()
                        focus = false
                    }
                        .foregroundStyle(.primary)
                }
            }
            .font(.title3)
            .disabled(!vm.state.interactionEnabled)
            
            switch vm.state {
            case .inProgress:
                ProgressView()
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title)
            case .validationError(let message):
                Text(message)
                    .foregroundStyle(.red)
            case .operationFailed(let reason):
                Text(reason)
                    .foregroundStyle(.red)
            case .canceled, .initial:
                EmptyView()
            }
        }
        .padding()
        .onAppear { focus = true }
    }
}

#Preview {
    TextOperationView("Preview", Preview.operationVM)
}

#Preview {
    TextOperationView("Preview", Preview.operationVM)
}
