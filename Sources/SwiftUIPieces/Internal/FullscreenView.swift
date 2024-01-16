//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.01.2024.
//

import Foundation
import SwiftUI

public extension View {
    func fullScreenOverlay<Item, Content>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item : Identifiable, Content : View {
        FullScreenOverlay(item, parent: self, content: content)
    }
}

struct FullScreenOverlay<Item, Content, Parent>: View where Item : Identifiable, Content : View, Parent: View {

    public var parent: Parent
    @ViewBuilder public var content: (Item) -> Content
    @Binding public var item: Item?

    @State private var doubleState = (presented: false, visible: false)
    @State private var animationInProgress = false
    
    public init(
        _ item: Binding<Item?>,
        parent: Parent,
        @ViewBuilder content: @escaping (Item) -> Content
    ) where Item : Identifiable, Content : View {
        self._item = item
        self.parent = parent
        self.content = content
    }
    
//    func updateDS() {
//        switch (item, animationInProgress):
//        case (nil,)
//    }
    
  var body: some View {
      parent
          .background(.yellow)
          .fullScreenCover(isPresented: $doubleState.presented) {
              if let item {
                  content(item)
              }
          }
              
//      Group {
//        if isCoverVisible {
//          FullScreenView(item: $item)
//            .onDisappear {
//              // dismiss the FullScreenCover
//              isCoverPresented = false
//            }
//        }
//      }
//      .onAppear {
//
//      }
    }
//    .transaction({ transaction in
//      // disable the default FullScreenCover animation
//      transaction.disablesAnimations = true
//
//      // add custom animation for presenting and dismissing the FullScreenCover
//        transaction.animation = .easeInOut(duration: 0.4)
//    })
//  }
}

struct PlaygroundOwner: View {

    @State var item: Int?
    
    var body: some View {
        Button("Show") { item = 1 }
            .fullScreenOverlay(item: $item) { anItem in
                Text("\(anItem)")
                    .presentationBackground(.green.opacity(0.5))
                Button("Hide") { item = nil}
            }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}


#Preview {
    PlaygroundOwner()
}
