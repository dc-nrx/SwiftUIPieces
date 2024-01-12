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
            Button("Add") { vm.onAdd() }
        }
        .sheet(item: $vm.addVM) { addVM in
            TextOperationView("Preview", addVM)
                .presentationDetents([.fraction(0.3), .large])
        }
    }
}

#Preview {
    SampleCallerView()
}
