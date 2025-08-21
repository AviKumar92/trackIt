//
//  CountdownOverlay.swift
//  HabitApp
//
//  Created by Avinash kumar on 21/08/25.
//

import UIKit

class CountdownOverlay: UIView {
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 80, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var timer: Timer?
    private var count = 3
    var completion: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        addSubview(countdownLabel)
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Countdown Logic
    func startCountdown(completion: @escaping () -> Void) {
        self.completion = completion
        count = 3
        countdownLabel.text = "\(count)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            guard let self = self else { return }
            self.count -= 1
            
            if self.count > 0 {
                self.animateLabel(text: "\(self.count)")
            } else if self.count == 0 {
                self.animateLabel(text: "GO!")
            } else {
                t.invalidate()
                self.removeFromSuperview()
                self.completion?()
            }
        }
    }
    
    // MARK: - Animation
    private func animateLabel(text: String) {
        countdownLabel.text = text
        countdownLabel.alpha = 0
        countdownLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.countdownLabel.alpha = 1
            self.countdownLabel.transform = .identity
        })
    }
}
