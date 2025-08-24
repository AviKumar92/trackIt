//
//  StatsCardView.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//

import UIKit

class StatsCardView: UIView {
    
    private let distanceLabel = UILabel()
    private let timeLabel = UILabel()
    private let paceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Distance
        distanceLabel.text = "Distance: 0.00 km"
        styleLabel(distanceLabel)
        
        // Time
        timeLabel.text = "Time: 00:00"
        styleLabel(timeLabel)
        
        // Pace
        paceLabel.text = "Pace: 0'00\"/km"
        styleLabel(paceLabel)
        
        // Stack layout
        let stack = UIStackView(arrangedSubviews: [distanceLabel, timeLabel, paceLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func styleLabel(_ label: UILabel) {
        label.textColor = .white
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Public Update Methods
    func update(distance: Double, time: Int) {
        distanceLabel.text = String(format: "Distance: %.2f km", distance)
        
        let minutes = time / 60
        let seconds = time % 60
        timeLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    func updatePace(distance: Double, time: Int) {
        if distance > 0 {
            let pace = Double(time) / distance // seconds per km
            let paceMin = Int(pace) / 60
            let paceSec = Int(pace) % 60
            paceLabel.text = String(format: "Pace: %d'%02d\"/km", paceMin, paceSec)
        } else {
            paceLabel.text = "Pace: 0'00\"/km"
        }
    }
}
