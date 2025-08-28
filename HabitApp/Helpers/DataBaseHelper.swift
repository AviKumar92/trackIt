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
       
       func save(object: [String: String]) {
           let habitdataObj = NSEntityDescription.insertNewObject(forEntityName: "Habitdata", into: context!) as! Habitdata
           habitdataObj.name = object["name"]
           habitdataObj.frequency = object["frequency"]
           habitdataObj.note = object["note"]
           habitdataObj.time = object["time"]
           do {
               try context?.save()
           } catch  {
               print("Data not saved")
           }
       }
       
       func getHabitData() -> [Habitdata] {
           var habit = [Habitdata]()
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Habitdata")
           
           do {
               habit =  try context?.fetch(fetchRequest) as! [Habitdata]
           } catch  {
               print("Can not get data")
           }
           return habit
       }
       
       func deleteData(index: Int) -> [Habitdata]{
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
       
       
       func editData(object: [String: String] , index:Int){
           var habitList = getHabitData()
           habitList[index].name = object["name"]
           habitList[index].frequency = object["frequency"]
           habitList[index].note = object["note"]
           habitList[index].time = object["time"]
           
           do {
               try context?.save()
           } catch  {
               print("cannot be editted")
           }
       }
   

}
