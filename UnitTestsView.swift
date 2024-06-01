//
//  UnitTestsView.swift
//  XCUTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import SwiftUI

struct UnitTestsView: View {
    @StateObject var viewModel: UnitTestsViewModel
    
    init(isPremium: Bool) {
        _viewModel = StateObject(wrappedValue: UnitTestsViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(viewModel.isPremium.description)
    }
}

struct UnitTestsView_Previews: PreviewProvider {
    
    static var previews: some View {
        UnitTestsView(isPremium: true)
    }
}
