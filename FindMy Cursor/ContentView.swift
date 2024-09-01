//
//  ContentView.swift
//  FindMy Cursor
//
//  Created by Robert Allen on 5/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("")
            .frame(width: 0, height: 0)
            .onAppear {
                MouseCursorFinder.shared.start()
            }
    }
}
