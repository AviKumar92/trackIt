//
//  ActivityTrackerViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 20/08/25.
//

import UIKit
import MapKit
import CoreLocation

class ActivityTrackerViewController: UIViewController {

    @IBOutlet weak var activityMapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userLocations: [CLLocation] = []   // store path points
    private var totalDistance: CLLocationDistance = 0.0

    // Countdown overlay
       private let countdownOverlay = UIView()
       private let countdownLabel = UILabel()
       private var countdownTimer: Timer?
       private var countdownValue = 3
       private var isCountingDown = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Activity Tracker"
       
    }
    
    func setUpActivityTracker(){
        activityMapView.showsUserLocation = true
        activityMapView.userTrackingMode = .follow
        activityMapView.delegate = self
        
        setupLocation();
    
    }
    
    private func setupLocation() {
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
           // Request permission
           locationManager.requestWhenInUseAuthorization()
           
           // Start location updates
           locationManager.startUpdatingLocation()
       }

    @IBAction func zoomInMap(_ sender: Any) {
        var region = activityMapView.region
               region.span.latitudeDelta /= 2
               region.span.longitudeDelta /= 2
        activityMapView.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOutMap(_ sender: Any) {
        var region = activityMapView.region
                region.span.latitudeDelta *= 2
                region.span.longitudeDelta *= 2
        activityMapView.setRegion(region, animated: true)
    }
    @IBAction func onClickStart(_ sender: Any) {
        
        let overlay = CountdownOverlay(frame: self.view.bounds)
            self.view.addSubview(overlay)
            
            overlay.startCountdown {
                print("🚀 Countdown finished — start tracking now")
                self.setUpActivityTracker()
            }
    }
}

extension ActivityTrackerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let newLocation = locations.last else { return }
            
            // Store location points
            if let lastLocation = userLocations.last {
                let distance = newLocation.distance(from: lastLocation) // meters
                if distance > 5 { // ignore small GPS jumps
                    totalDistance += distance
                    print("Total Distance: \(totalDistance / 1000) km")
                    userLocations.append(newLocation)
                    drawPath()
                }
            } else {
                // First location → center map here
                let region = MKCoordinateRegion(
                    center: newLocation.coordinate,
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
                activityMapView.setRegion(region, animated: true)
                userLocations.append(newLocation)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location error: \(error.localizedDescription)")
        }
        
       
}

extension ActivityTrackerViewController: MKMapViewDelegate {
    
    func drawPath() {
          let coordinates = userLocations.map { $0.coordinate }
          guard coordinates.count > 1 else { return } // need at least 2 points
          
          // Remove old overlays before drawing new one
          activityMapView.removeOverlays(activityMapView.overlays)
          
          let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        activityMapView.addOverlay(polyline)
      }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
}
