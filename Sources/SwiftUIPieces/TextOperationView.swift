//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 10.01.2024.
//

import SwiftUI

struct TextOperationView<Output>: View {
	
	@ObservedObject var vm: OperationVM<String, Output>
	
    var body: some View {
		VStack {
			Group {
                Text(vm.title)
                    .font(.title3)
				TextField("Placeholder", text: $vm.input)
				HStack {
                    Button("Cancel") { vm.onCancel() }
					Spacer()
                    Button("Confirm") { vm.onSubmit() }
				}
			}
            .disabled(!vm.state.interactionEnabled)
			
            switch vm.state {
			case .inProgress:
				ProgressView()
			case .success:
				Text("Success!")
					.foregroundStyle(.green)
			case .validationError(let message):
				Text("Validation error: \(message)")
					.foregroundStyle(.red)
			case .operationFailed(let reason):
				Text("Operation failed. Reason: \(reason)")
			case .canceled:
				Text("Operation cancelled")
			case .initial:
				EmptyView()
			}
            Text("\(vm.state.str)")
		}
		.padding()
    }
}

#Preview {
    TextOperationView(vm: OperationVM(title: "Sample") { text in
		try! await Task.sleep(for: .seconds(1))
		if Bool.random() || Bool.random() {
			throw NSError()
		} else {
			print("whoa! the text is: \(text)")
		}
	})
}
