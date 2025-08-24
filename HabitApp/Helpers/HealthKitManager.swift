//
//  HealthKitManager.swift
//  HabitApp
//
//  Created by Avinash kumar on 21/08/25.
//

import HealthKit
import UIKit

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    func requestPermissions(completion: @escaping (Bool, Error?) -> Void) {
        let sampleTypesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead, completion: completion)
    }
    
    private func get24hPredicate() -> NSPredicate {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
        return HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
    }
    
    // MARK: - Readers
    
    func fetchSteps(completion: @escaping (HealthActivityData?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let query = HKStatisticsQuery(quantityType: type,
                                      quantitySamplePredicate: get24hPredicate(),
                                      options: .cumulativeSum) { _, results, _ in
            guard let sum = results?.sumQuantity() else { completion(nil); return }
            let totalSteps = Int(sum.doubleValue(for: HKUnit.count()))
            completion(HealthActivityData(mainInfo: "Steps", subInfo: "steps", unit: "\(totalSteps)",color: UIColor(red: 0.65, green: 0.85, blue: 1.0, alpha: 1.0), iconName: "figure.walk"))
        }
        healthStore.execute(query)
    }
    
    func fetchHeartRate(completion: @escaping (HealthActivityData?) -> Void) {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: get24hPredicate(),
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { _, results, _ in
            guard let sample = results?.first as? HKQuantitySample else { completion(nil); return }
            let bpm = Int(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
            completion(HealthActivityData(mainInfo: "Heart Rate", subInfo: "BPM", unit: "\(bpm)", color: UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), iconName: "heart.fill"))
            
        }
        healthStore.execute(query)
    }
    
    
    func fetchSleep(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: type,
                                      predicate: get24hPredicate(),
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor]) { _, results, _ in
                guard let results = results as? [HKCategorySample] else { completion(nil); return }
                
                var totalSleep: TimeInterval = 0
                for sample in results {
                    if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                        totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                    }
                }
                
                let hours = Int(totalSleep / 3600)
                let minutes = Int((totalSleep.truncatingRemainder(dividingBy: 3600)) / 60)
                let sleepStr = "\(hours)h \(minutes)m"
                completion(HealthActivityData(mainInfo: "Sleep", subInfo: sleepStr, unit: "",color: UIColor(red: 0.85, green: 0.9, blue: 0.75, alpha: 1.0), iconName: "bed.double..fill"))

            }
            healthStore.execute(query)
        }
        
        func fetchActiveEnergy(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
            let query = HKStatisticsQuery(quantityType: type,
                                          quantitySamplePredicate: get24hPredicate(),
                                          options: .cumulativeSum) { _, results, _ in
                guard let sum = results?.sumQuantity() else { completion(nil); return }
                let kcal = Int(sum.doubleValue(for: .kilocalorie()))
                completion(HealthActivityData(mainInfo: "Calories", subInfo: "\(kcal)", unit: "kcal",color: UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0), iconName: "flame.fill"))

            }
            healthStore.execute(query)
        }
        
        func fetchDistance(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
            let query = HKStatisticsQuery(quantityType: type,
                                          quantitySamplePredicate: get24hPredicate(),
                                          options: .cumulativeSum) { _, results, _ in
                guard let sum = results?.sumQuantity() else { completion(nil); return }
                let km = sum.doubleValue(for: .meter()) / 1000.0
                completion(HealthActivityData(mainInfo: "Distance", subInfo: String(format: "%.2f", km), unit: "km",color: UIColor(red: 1.0, green: 0.7, blue: 0.8, alpha: 1.0), iconName: "flame.fill"))

            }
            healthStore.execute(query)
        }
        
        func fetchFlights(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.quantityType(forIdentifier: .flightsClimbed) else { return }
            let query = HKStatisticsQuery(quantityType: type,
                                          quantitySamplePredicate: get24hPredicate(),
                                          options: .cumulativeSum) { _, results, _ in
                guard let sum = results?.sumQuantity() else { completion(nil); return }
                let floors = Int(sum.doubleValue(for: .count()))
                completion(HealthActivityData(mainInfo: "Flights", subInfo: "\(floors)", unit: "floors",color: UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), iconName: "flame.fill"))
            }
            healthStore.execute(query)
        }
        
        func fetchRestingHeartRate(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else { return }
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: type,
                                      predicate: get24hPredicate(),
                                      limit: 1,
                                      sortDescriptors: [sortDescriptor]) { _, results, _ in
                guard let sample = results?.first as? HKQuantitySample else { completion(nil); return }
                let bpm = Int(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
                completion(HealthActivityData(mainInfo: "Resting HR", subInfo: "\(bpm)", unit: "BPM",color: UIColor(red: 1.0, green: 0.84, blue: 0.8, alpha: 1.0), iconName: "heart.fill"))
            }
            healthStore.execute(query)
        }
        
        func fetchMindfulMinutes(completion: @escaping (HealthActivityData?) -> Void) {
            guard let type = HKObjectType.categoryType(forIdentifier: .mindfulSession) else { return }
            let query = HKSampleQuery(sampleType: type,
                                      predicate: get24hPredicate(),
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: nil) { _, results, _ in
                guard let sessions = results as? [HKCategorySample] else { completion(nil); return }
                
                var totalMinutes: TimeInterval = 0
                for session in sessions {
                    totalMinutes += session.endDate.timeIntervalSince(session.startDate)
                }
                let minutes = Int(totalMinutes / 60)
                completion(HealthActivityData(mainInfo: "Mindful", subInfo: "\(minutes)", unit: "min",color: UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), iconName: "flame.fill"))
            }
            healthStore.execute(query)
        }
}

