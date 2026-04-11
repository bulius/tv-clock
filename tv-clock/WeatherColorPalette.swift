//
//  WeatherColorPalette.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import SwiftUI
import WeatherKit

struct WeatherColorPalette {
    let lightTop: Color
    let lightBottom: Color
    let darkTop: Color
    let darkBottom: Color

    func gradient(for colorScheme: ColorScheme) -> LinearGradient {
        let top = colorScheme == .dark ? darkTop : lightTop
        let bottom = colorScheme == .dark ? darkBottom : lightBottom
        return LinearGradient(
            colors: [top, bottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Weather-based palettes

    static func palette(for condition: WeatherCondition?) -> WeatherColorPalette {
        guard let condition else { return .default }

        switch condition {
        case .clear, .mostlyClear, .hot:
            return .clear
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            return .cloudy
        case .rain, .heavyRain, .drizzle, .sunShowers:
            return .rain
        case .thunderstorms, .scatteredThunderstorms, .isolatedThunderstorms, .strongStorms:
            return .storm
        case .snow, .flurries, .blowingSnow, .sleet, .wintryMix, .freezingRain, .sunFlurries:
            return .snow
        case .foggy, .haze, .smoky, .blowingDust:
            return .fog
        default:
            return .default
        }
    }

    // MARK: - Palette definitions

    /// Warm amber tones for clear skies
    static let clear = WeatherColorPalette(
        lightTop: Color(red: 0.98, green: 0.92, blue: 0.78),
        lightBottom: Color(red: 0.95, green: 0.85, blue: 0.65),
        darkTop: Color(red: 0.08, green: 0.10, blue: 0.22),
        darkBottom: Color(red: 0.05, green: 0.07, blue: 0.18)
    )

    /// Cool gray tones for overcast skies
    static let cloudy = WeatherColorPalette(
        lightTop: Color(red: 0.85, green: 0.87, blue: 0.90),
        lightBottom: Color(red: 0.80, green: 0.82, blue: 0.86),
        darkTop: Color(red: 0.14, green: 0.15, blue: 0.18),
        darkBottom: Color(red: 0.10, green: 0.11, blue: 0.14)
    )

    /// Steel blue tones for rain
    static let rain = WeatherColorPalette(
        lightTop: Color(red: 0.78, green: 0.85, blue: 0.92),
        lightBottom: Color(red: 0.70, green: 0.78, blue: 0.88),
        darkTop: Color(red: 0.06, green: 0.10, blue: 0.20),
        darkBottom: Color(red: 0.04, green: 0.07, blue: 0.16)
    )

    /// Deep purple-indigo tones for storms
    static let storm = WeatherColorPalette(
        lightTop: Color(red: 0.80, green: 0.78, blue: 0.88),
        lightBottom: Color(red: 0.72, green: 0.70, blue: 0.82),
        darkTop: Color(red: 0.10, green: 0.08, blue: 0.20),
        darkBottom: Color(red: 0.06, green: 0.05, blue: 0.15)
    )

    /// Icy pale blue tones for snow
    static let snow = WeatherColorPalette(
        lightTop: Color(red: 0.90, green: 0.93, blue: 0.96),
        lightBottom: Color(red: 0.85, green: 0.89, blue: 0.94),
        darkTop: Color(red: 0.10, green: 0.13, blue: 0.20),
        darkBottom: Color(red: 0.07, green: 0.10, blue: 0.17)
    )

    /// Warm muted beige tones for fog
    static let fog = WeatherColorPalette(
        lightTop: Color(red: 0.90, green: 0.88, blue: 0.84),
        lightBottom: Color(red: 0.86, green: 0.84, blue: 0.80),
        darkTop: Color(red: 0.16, green: 0.15, blue: 0.13),
        darkBottom: Color(red: 0.12, green: 0.11, blue: 0.10)
    )

    /// Neutral fallback when weather is unavailable
    static let `default` = WeatherColorPalette(
        lightTop: Color(red: 0.95, green: 0.95, blue: 0.95),
        lightBottom: Color(red: 0.92, green: 0.92, blue: 0.92),
        darkTop: Color(red: 0.11, green: 0.11, blue: 0.12),
        darkBottom: Color(red: 0.08, green: 0.08, blue: 0.09)
    )
}
