//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.01.2024.
//

import Foundation
import SwiftUI

public extension View {
    func customFullScreen<Item, Content>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil, 
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item : Identifiable, Content : View {
        EmptyView()
    }
}

struct FullScreenContainer: View {
  @State var isFullScreenCoverPresented = false
//  @State var isFullScreenViewVisible = false

    @State var k = 1
    
    var isFullScreenViewVisible: Bool { k % 2 == 0 }
    
  var body: some View {
    VStack {
        Text("xcc")
        Spacer()
      Button("Tap me") {
        isFullScreenCoverPresented = true
      }
    }.fullScreenCover(isPresented: $isFullScreenCoverPresented) {
      Group {
        if isFullScreenViewVisible {
          FullScreenView(k: $k)
            .onDisappear {
              // dismiss the FullScreenCover
              isFullScreenCoverPresented = false
            }
        }
      }
      .onAppear {
        k = 2
      }
    }
    .transaction({ transaction in
      // disable the default FullScreenCover animation
      transaction.disablesAnimations = true

      // add custom animation for presenting and dismissing the FullScreenCover
        transaction.animation = .easeInOut(duration: 0.4)
    })
  }
}

struct FullScreenView: View {
//  @Binding var isVisible: Bool

    @Binding var k: Int
  var body: some View {
    VStack {
      Button("Dismiss") {
        k = 1
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .presentationBackground(.green.opacity(0.5))
    }
  }
}

#Preview {
    FullScreenContainer()
}
