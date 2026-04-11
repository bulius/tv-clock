//
//  WeatherManager.swift
//  tv-clock
//
//  Created by Julius Santiago on 4/6/26.
//

import CoreLocation
import SwiftUI
import WeatherKit

@Observable
final class WeatherManager: NSObject, CLLocationManagerDelegate {
    private(set) var condition: WeatherCondition?

    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService.shared
    private var refreshTask: Task<Void, Never>?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }

    func start() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchWeather(for: location)
        startPeriodicRefresh(for: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Silently fall back to default palette
    }

    // MARK: - Weather fetching

    private func fetchWeather(for location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location, including: .current)
                await MainActor.run {
                    self.condition = weather.condition
                }
            } catch {
                // Fall back to default palette on error
            }
        }
    }

    private func startPeriodicRefresh(for location: CLLocation) {
        refreshTask?.cancel()
        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(900)) // 15 minutes
                guard !Task.isCancelled else { break }
                fetchWeather(for: location)
            }
        }
    }
}
