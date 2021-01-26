//
//  TextValidationHelper.swift
//  Vilanov
//
//  Created by andres on 2/28/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation

class TextValidationHelper {
    
    static func isValidDNILength(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9A-Za-z]{6,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    static func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^((\\++)|(0))[0-9]{8,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //valid string: One upper, one number, one special character. min:8
    static func isValidPassword(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,32}")
        return passwordTest.evaluate(with: password)
    }
    
    //valid string: One upper, one number. min:8, max:32
    static func isValidPasswordOneCharOneNumber(_ password: String, minChars min: Int, maxChars max: Int) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[A-Z])[A-Za-z\\d]{\(min),\(max)}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidPasswordLenth(password: String , confirmPassword : String) -> Bool {
        if password.count <= 7 && confirmPassword.count <= 7{
            return true
        }else{
            return false
        }
    }
    
    static func isValidPincode4(value: String) -> Bool {
        if value.count == 4 {
            return true
        }
        else {
            return false
        }
    }
    
    static func isValidPincode6(value: String) -> Bool {
        if value.count == 4 {
            return true
        }
        else {
            return false
        }
    }
    
    static func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    
    static func isNotFutureDate(from string: String) -> Bool {
        var isNotFuture = false
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let fecha = formatter.date(from: string) {
            if(date.timeIntervalSince1970 >= fecha.timeIntervalSince1970) {
                isNotFuture = true
            }
        }
        return isNotFuture
    }
    
    static func esMayorDeEdadCon(fechaNacimiento: Date, factorMayoriaEdad: Int) -> Bool{
        let calendar = Calendar.current
        let component = Set<Calendar.Component>([.day, .month, .year])
        
        let datecomponentsActual = calendar.dateComponents(component, from: Date())
        let diaActual = datecomponentsActual.day!
        let mesActual = datecomponentsActual.month!
        let anioActual = datecomponentsActual.year!
        
        let datecomponentsFecNac = calendar.dateComponents(component, from: fechaNacimiento)
        let diaFecNac = datecomponentsFecNac.day!
        let mesFecNac = datecomponentsFecNac.month!
        let anioFecNac = datecomponentsFecNac.year!
        
        if anioActual-anioFecNac == factorMayoriaEdad {
            if mesActual-mesFecNac == 0 {
                if diaActual-diaFecNac >= 0 {
                    print("Eres mayor de edad")
                    return true
                }else{
                    print("No eres mayor de edad")
                    return false
                }
            }else if mesActual-mesFecNac > 0 {
                print("Eres mayor de edad")
                return true
            }else{
                print("No eres mayor de edad")
                return false
            }
        }else if anioActual-anioFecNac > factorMayoriaEdad {
            print("Eres mayor de edad")
            return true
        }else{
            print("No eres mayor de edad")
            return false
        }
    }
    
    static func isYearBetween(_ year: Int, _ minYear: Int, _ maxYear: Int) -> Bool {
        if(year < minYear) {
            return false
        }
        if(year > maxYear) {
            return false
        }
        return true
    }
}
