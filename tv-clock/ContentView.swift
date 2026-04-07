//
//  ContentView.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var weatherManager = WeatherManager()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    private var palette: WeatherColorPalette {
        .palette(for: weatherManager.condition)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            Text(timeFormatter.string(from: context.date))
                .font(.system(size: 180, weight: .medium, design: .monospaced))
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal, 40)
                .contentTransition(.numericText())
                .animation(.default, value: context.date)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(palette.gradient(for: colorScheme))
        .animation(.easeInOut(duration: 1.0), value: weatherManager.condition)
        .onAppear {
            weatherManager.start()
        }
    }
}

#Preview {
    ContentView()
}
