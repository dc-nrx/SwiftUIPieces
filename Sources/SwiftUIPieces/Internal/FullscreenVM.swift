//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.01.2024.
//

import Foundation
import SwiftUI

final class FullscreenVM<Item> {
    
    @Published var item: Item?
    @Published private(set) var overlayActive = false //binding?
    @Published private(set) var overlayVisible = false
    
    init(_ item: Item?) {
        self.item = item
    }
    
    func show() {
        overlayActive = true
        withAnimation {
            overlayVisible = true
        }
    }
    
    func hide() {
        withAnimation {
            self.overlayVisible = false
        }
        //        } completion: {
        //            self.overlayActive = false
        //        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.overlayActive = false
        }
    }
}
