//
//  HealthDataViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit
import HealthKit

class HealthDataViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    private var healthStore: HKHealthStore?
    @IBOutlet weak var healthDataCollectionView: UICollectionView!
    var datalist:[HealthActivityData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "HealthDataCollectionViewCell", bundle: nil)
        healthDataCollectionView.register(nibCell, forCellWithReuseIdentifier: "HealthData")
        healthDataCollectionView.delegate = self
        healthDataCollectionView.dataSource = self
        
        // Request permission first
                HealthKitManager.shared.requestPermissions { success, error in
                    if success {
                        self.loadHealthData()
                    } else {
                        print("HealthKit permission denied: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
    }
   

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthData", for: indexPath) as! HealthDataCollectionViewCell
        cell.bindData(data: datalist[indexPath.row])
        return cell
    }
    
    private func loadHealthData() {
           datalist.removeAll()
           
           let fetchers: [( (@escaping (HealthActivityData?) -> Void) -> Void )] = [
               HealthKitManager.shared.fetchSteps,
               HealthKitManager.shared.fetchHeartRate,
               HealthKitManager.shared.fetchSleep,
               HealthKitManager.shared.fetchActiveEnergy,
               HealthKitManager.shared.fetchDistance,
               HealthKitManager.shared.fetchFlights,
               HealthKitManager.shared.fetchRestingHeartRate,
               HealthKitManager.shared.fetchMindfulMinutes
           ]
           
           for fetch in fetchers {
               fetch { data in
                   if let data = data {
                       DispatchQueue.main.async {
                           self.datalist.append(data)
                           self.healthDataCollectionView.reloadData()
                       }
                   }
               }
           }
       }
   }
    

extension HealthDataViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let itemWidth = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: itemWidth, height: 140)
            }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
