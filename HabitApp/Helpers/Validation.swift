//
//  Validation.swift
//  HabitApp
//
//  Created by Avinash kumar on 25/08/25.
//

import Foundation

class Validation{
     func validateName(Name:String) -> (Bool){
         let nameRegex = "^[A-Za-z]+(?:\\s[A-Za-z]+)*$"
         let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            return namePredicate.evaluate(with: Name)
    }
    
    func validateEmail(Email:String) -> (Bool){
//        let emailRegEx = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$"
//        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        //let emailRegEx = "^[a-zA-Z0-9._%+-]+@gmail\\.com$"
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"


            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPred.evaluate(with: Email)
    }
    
    func validatePassword(Password:String) -> Bool{
       // let confirmRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passRegex = "^.{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passRegex).evaluate(with: Password)
    }
    func validConfirmPassword(ConfirmPassword:String) -> Bool{
       // let confirmRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passRegex = "^.{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passRegex).evaluate(with: ConfirmPassword)
    }
    func validatePhonenumber(Phonenumber:String) -> (Bool){
//        let phoneRegex = "^\+([1-9][0-9]{0,2})[-\s]?([0-9\s\-()]{5,16})$"
      //  let phoneRegex = "^\\+([1-9][0-9]{0,2})[-\\s]?([0-9\\s\\-()]{5,16})$"
        let phoneRegex = #"^\+\d{1,3}\s?\d{10}$"#


                let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
                return phonePred.evaluate(with: Phonenumber)
    }
}
