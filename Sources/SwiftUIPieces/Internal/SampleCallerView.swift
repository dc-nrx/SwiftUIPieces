//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.01.2024.
//

import SwiftUI

struct SampleCallerView: View {
        
    @StateObject var vm = SampleCallerVM()
    @State var fullscreenOverlayShown = false
    
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
        .background(.green.opacity(0.3))
        .sheet(item: $vm.addVM) { addVM in
//            withAnimation {
                TextOperationView("Preview", addVM)
                    .presentationDetents([.fraction(0.3), .large])
//            }
        }
        .fullScreenCover(item: $vm.voidVM) { voidVM in
            switch voidVM.state {
            case .inProgress: ProgressView()
                    .background(.yellow.opacity(0.3))
                    .opacity(vm.voidVM == nil ? 0 : 1)
            case .success: Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            default: Text("Unexpected")
            }
        }
//        .transi
//        .transaction { transaction in
//            transaction.animation = 
//        }
//        .animation(.easeInOut, value: fullscreenOverlayShown)
//        .animation(.linear(duration: 0.4))
//            .animation(.linear(duration: 0.5), value: isFullScreenViewVisible)
    }
}

#Preview {
    SampleCallerView()
}
