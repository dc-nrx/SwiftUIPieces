//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import SwiftUI

struct SampleCallerView: View {
        
    @StateObject var vm = SampleCallerVM()

    var body: some View {
        VStack {
            Text(vm.title)
                .font(.title)
            Spacer()
            HStack {
                Button("Launch Void") { vm.onVoid() }
                Spacer()
                Button("Add") { vm.onAdd() }
            }
            .padding()
        }
        .sheet(item: $vm.addVM) { addVM in
            TextOperationView("Preview", addVM)
                .presentationDetents([.fraction(0.3), .large])
                .animation(.easeInOut)
        }
        .overlay {
            if let voidVM = vm.voidVM {
                switch voidVM.state {
                case .inProgress: ProgressView()
                case .success: Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                default: Text("Unexpected")
                }
            }
        }
        .animation(.easeInOut)
    }
}

#Preview {
    SampleCallerView()
}
