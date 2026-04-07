//
//  ContentView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import SwiftUI

struct ContentView: View {
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            Text(timeFormatter.string(from: context.date))
                .font(.system(size: 180, weight: .medium, design: .monospaced))
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .contentTransition(.numericText())
                .animation(.default, value: context.date)
        }
    }
}

#Preview {
    ContentView()
}
