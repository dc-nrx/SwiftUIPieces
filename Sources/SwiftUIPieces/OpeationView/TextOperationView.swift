//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import SwiftUI

public struct TextOperationView: View {
	
    let title: String
    let placeholder: String
	
    @ObservedObject var vm: InputAsyncOperation<String>
	
    @FocusState private var focus: Bool
    
    public init(
        _ title: String,
        placeholder: String = "",
        _ vm: InputAsyncOperation<String>
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
                    .onSubmit { vm.execute() }
                Spacer()
                stateView
                Spacer()
                HStack {
                    Button("Cancel") { vm.cancel() }
                        .foregroundStyle(.secondary)
                        .bold()
                    Spacer()
                    Button("Confirm") {
                        vm.execute()
                        focus = false
                    }
                        .foregroundStyle(.primary)
                }
            }
            .font(.title3)
            .disabled(!vm.state.interactionEnabled)
        }
        .padding()
        .onAppear { focus = true }
    }
    
    @ViewBuilder
    private var stateView: some View {
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
}

#Preview {
    TextOperationView("Preview", Preview.inputOpVM)
}

#Preview {
    TextOperationView("Preview", Preview.inputOpVM)
}
