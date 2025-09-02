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
    
    var onFinished: ((Activity) -> Void)?
    
    private var isTracking = false
    private var startDate: Date?
    private var activityTimer: Timer?
    private var elapsedSeconds = 0
    
    private var statsCard: StatsCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Activity Tracker"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Request permission
        locationManager.requestWhenInUseAuthorization()
        
        statsCard = StatsCardView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height-200, width: view.bounds.width - 40, height: 80))
        view.addSubview(statsCard)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled(),
           let location = locationManager.location {
            
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            activityMapView.setRegion(region, animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let top = UIColor(red: 158/255, green: 235/255, blue: 199/255, alpha: 1)   // #9EEBC7
                let bottom = UIColor(red: 255/255, green: 241/255, blue: 166/255, alpha: 1) // #FFF1A6
                view.applyGradient(colors: [top, bottom])
    }
    
    func setUpActivityTracker(){
        activityMapView.showsUserLocation = true
        activityMapView.userTrackingMode = .follow
        activityMapView.delegate = self
        
        setupLocation();
        
    }
    
    private func setupLocation() {
        
        
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
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            let overlay = CountdownOverlay(frame: self.view.bounds)
            self.view.addSubview(overlay)
            overlay.startCountdown { [weak self] in
                guard let self = self else { return }
                self.setUpActivityTracker()
                self.startDate = Date()
                self.elapsedSeconds = 0
                self.activityTimer?.invalidate()
                self.activityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                    self?.elapsedSeconds += 1
                }
                self.isTracking = true
            }
            
        } else {
            print("⚠️ Location permission not granted")
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    @IBAction func onClickStop(_ sender: Any) {
        
        guard isTracking else { return }
        isTracking = false
        
        locationManager.stopUpdatingLocation()
        activityTimer?.invalidate()
        activityTimer = nil
        
        let endDate = Date()
        let points = userLocations.map { TrackPoint($0) }
        var activity = Activity(startDate: startDate ?? endDate,
                                endDate: endDate,
                                distanceMeters: totalDistance,
                                points: points)
        
        // Optional: drop an End pin
        if let last = userLocations.last {
            let endPin = MKPointAnnotation()
            endPin.coordinate = last.coordinate
            endPin.title = "End"
            activityMapView.addAnnotation(endPin)
        }
        
        // 3. Generate route snapshot and attach it to the activity
        let coordinates = userLocations.map { $0.coordinate }
        MapSnapshotHelper.generateSnapshot(for: coordinates) { snapshot in
            if let snapshot = snapshot {
                activity.snapshot = snapshot
            }
            
            
            // Hand back to feed; feed will persist & pop
            self.onFinished?(activity)
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
        
        statsCard.update(distance: totalDistance / 1000, time: elapsedSeconds)
        statsCard.updatePace(distance: totalDistance / 1000, time: elapsedSeconds)

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
