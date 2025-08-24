//
//  MapSnapshotHelper.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//

import MapKit

class MapSnapshotHelper {
    static func generateSnapshot(for coordinates: [CLLocationCoordinate2D],
                                 size: CGSize = CGSize(width: 300, height: 200),
                                 completion: @escaping (UIImage?) -> Void) {
        guard !coordinates.isEmpty else {
            completion(nil)
            return
        }

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let region = MKCoordinateRegion(polyline.boundingMapRect)

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }

            let image = snapshot.image
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: .zero)

            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.systemBlue.cgColor)
            context?.setLineWidth(4)

            let points = coordinates.map { snapshot.point(for: $0) }
            if let firstPoint = points.first {
                context?.move(to: firstPoint)
                for point in points.dropFirst() {
                    context?.addLine(to: point)
                }
                context?.strokePath()
            }

            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            completion(finalImage)
        }
    }
}
