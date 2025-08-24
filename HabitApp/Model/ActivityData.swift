//
//  Untitled.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//
import Foundation
import CoreLocation
import UIKit

struct TrackPoint: Codable {
    let lat: Double
    let lon: Double
    let ts: TimeInterval  // seconds since 1970

    init(_ location: CLLocation) {
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        self.ts = location.timestamp.timeIntervalSince1970
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct Activity: Codable, Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let distanceMeters: Double
    let durationSec: Int
    let points: [TrackPoint]
    var snapshotData: Data? // store encoded image data
        var snapshot: UIImage? {
            get {
                if let data = snapshotData {
                    return UIImage(data: data)
                }
                return nil
            }
            set {
                snapshotData = newValue?.jpegData(compressionQuality: 0.8)
            }
        }

    
    
    init(startDate: Date, endDate: Date, distanceMeters: Double, points: [TrackPoint]) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.distanceMeters = distanceMeters
        self.durationSec = Int(endDate.timeIntervalSince(startDate))
        self.points = points
        self.snapshotData = nil
    }
}

extension Activity {
    var distanceKmString: String {
        String(format: "%.2f km", distanceMeters / 1000.0)
    }
    var durationString: String {
        let s = durationSec
        let h = s / 3600, m = (s % 3600) / 60, sec = s % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, sec)
                     : String(format: "%02d:%02d", m, sec)
    }
    var startDateString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: startDate)
    }
}

