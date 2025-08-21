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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHealthDataAvailable()
        readTotalStepCount()
        readHeartRate()
      let nibCell = UINib(nibName: "HealthDataCollectionViewCell", bundle: nil)
        healthDataCollectionView.register(nibCell, forCellWithReuseIdentifier: "HealthData")
        healthDataCollectionView.delegate = self
        healthDataCollectionView.dataSource = self
        
    }
    private func requestHealthkitPermissions() {
           
           let sampleTypesToRead = Set([
               HKObjectType.quantityType(forIdentifier: .heartRate)!,
               HKObjectType.quantityType(forIdentifier: .stepCount)!,
               HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
           ])
           
           healthStore?.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
               print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
           }
       }

    private func isHealthDataAvailable() {
        guard HKHealthStore.isHealthDataAvailable() else {  fatalError("This app requires a device that supports HealthKit") }
        healthStore = HKHealthStore()
                requestHealthkitPermissions()
    }
    
    
    func readTotalStepCount() {
        
        guard HKHealthStore.isHealthDataAvailable() else {  return }

            guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
                fatalError("*** Unable to get the step count type ***")
            }
            
            let query = HKStatisticsQuery.init(quantityType: stepCountType,
                                               quantitySamplePredicate: get24hPredicate(),
                                               options: [HKStatisticsOptions.cumulativeSum, HKStatisticsOptions.separateBySource]) { (query, results, error) in
                let totalStepCount = results?.sumQuantity()!.doubleValue(for: HKUnit.count())
                print("Total step count: \(totalStepCount ?? 0)")
                if ((results?.sources) != nil){
                    for source in (results?.sources)! {
                        let separateSourceStepCount = results?.sumQuantity(for: source)!.doubleValue(for: HKUnit.count())
                        print("Seperate Source total step count: \(separateSourceStepCount ?? 0)")
                    }
                }
            }
            
            healthStore?.execute(query)
        }
    
    private func get24hPredicate() ->  NSPredicate{
            let today = Date()
            let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
            let predicate = HKQuery.predicateForSamples(withStart: startDate,end: today,options: [])
            return predicate
        }
    
    private func readHeartRate(){
           let quantityType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
           let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
           let sampleQuery = HKSampleQuery.init(sampleType: quantityType,
                                                predicate: get24hPredicate(),
                                                limit: HKObjectQueryNoLimit,
                                                sortDescriptors: [sortDescriptor],
                                                resultsHandler: { (query, results, error) in
               
               guard let samples = results as? [HKQuantitySample] else {
                   print(error!)
                   return
               }
               for sample in samples {
                   let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                   print("Heart rate : \(mSample)")
               }
               
           })
           self.healthStore? .execute(sampleQuery)
           
       }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HealthData", for: indexPath) as! HealthDataCollectionViewCell
        return cell
    }
 
    
}
extension HealthDataViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 170, height: 100)
            }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
