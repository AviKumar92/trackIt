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
//           let habitdataObj = NSEntityDescription.insertNewObject(forEntityName: "Habits", into: context!) as! Habits
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
       
       func deleteData(index: Int) -> [Habits]{
           var habitList = getHabitData()
           context?.delete(habitList[index])
           habitList.remove(at: index)
           do {
               try context?.save()
           } catch  {
               print("cannot be deleted")
           }
           return habitList
       }
       
       
       func editData( habit: Habits , index:Int){
//           var habitList = getHabitData()
//           habitList[index].name = object["name"]
//           habitList[index].frequency = object["frequency"]
//           habitList[index].note = object["note"]
//           habitList[index].time = object["time"]
           
           do {
               try context?.save()
           } catch  {
               print("cannot be editted")
           }
       }
   

}
