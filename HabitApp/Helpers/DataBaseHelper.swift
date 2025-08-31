//
//  DataBaseHelper.swift
//  HabitApp
//
//  Created by Avinash kumar on 25/08/25.
//

import Foundation
import CoreData
import UIKit
class DataBaseHelper {
    
    
       static let sharedInstance = DataBaseHelper()
       let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
       
       func save(_ habit: Habits) {
           do {
               try context?.save()
           } catch  {
               print("Data not saved")
           }
       }
       
       func getHabitData() -> [Habits] {
           var habit = [Habits]()
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habits")
           
           do {
               habit =  try context?.fetch(fetchRequest) as! [Habits]
           } catch  {
               print("Can not get data")
           }
           return habit
       }

    func deleteHabit(habit:Habits){
        if let context = context {
            context.delete(habit)
            do {
                try context.save()
            }
            catch {
                print("Error deleting habit: \(error)")
            }
        }
    }
       
       func editData( habit: Habits , index:Int){
           do {
               try context?.save()
           } catch  {
               print("cannot be editted")
           }
       }
   
    func fetchHabitLog(habit: Habits, on date: Date) -> HabitLog? {
        let req: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "habit == %@ AND date >= %@ AND date < %@",
                                    habit, TrackHabitHelpers.startOfDay(date) as NSDate, TrackHabitHelpers.endOfDay(date) as NSDate)
        return try? context?.fetch(req).first
    }

    // Get or create a log (used when user toggles)
    func getOrCreateHabitLog(habit: Habits, on date: Date) -> HabitLog {
        
        if let existing = fetchHabitLog(habit: habit, on: date) { return existing }
        if let context = context {
            let log = HabitLog(context: context)
            log.habit = habit
            log.date = TrackHabitHelpers.startOfDay(date)
            log.isCompleted = false
            return log
        }
       return HabitLog()
    }
}
