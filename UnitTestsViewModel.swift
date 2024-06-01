//
//  UnitTestsViewModel.swift
//  XCUTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import Foundation
import SwiftUI

class UnitTestsViewModel: ObservableObject {
    
    @Published var isPremium: Bool
    
    init(isPremium: Bool) {
        self.isPremium = isPremium
    }
}
