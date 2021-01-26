//
//  CoreDataManager.swift
//  appgenerica
//
//  Created by paladinesa on 4/8/17.
//  Copyright © 2017 orflor. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
    /**
     *  Select de datos
     * Se retorna array de los objetos encontrados en la busqueda
     */
    static func listaDe<T: NSManagedObject>(entity: T.Type, multiPredicate: [NSPredicate]? = nil, sortDescriptor: [NSSortDescriptor]? = nil,
                        context: NSManagedObjectContext = CoreDataStack.managedObjectContext) -> NSMutableArray? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        var predicates = [NSPredicate]()
        if(multiPredicate != nil){
            for predic in multiPredicate!{
                predicates.append(predic)
            }
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                // returns mutable copy of result array
                return NSMutableArray.init(array: searchResult)
            } else {
                // returns nil in case no object found
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     * Borrado de datos
     * Se borran los objetos encontrados en la busqueda
     */
    static func borrarObjetos<T: NSManagedObject>(entity: T.Type,
                              multiPredicate: [NSPredicate]? = nil,
                              sortDescriptor: [NSSortDescriptor]? = nil,
                              context: NSManagedObjectContext = CoreDataStack.managedObjectContext) -> Bool? {
        var response = false
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        var predicates = [NSPredicate]()
        if(multiPredicate != nil){
            for predic in multiPredicate!{
                predicates.append(predic)
            }
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                // returns mutable copy of result array
                for object in searchResult {
                    context.delete(object)
                }
                response = true
            }
            do {
                try context.save() // <- remember to put this :)
            } catch {
                return nil
            }
            
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     * Truncar tabla
     * Se borran los objetos encontrados en la busqueda
     */
    static func truncarObjetos<T: NSManagedObject>(entity: T.Type, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) -> Bool {
        var response = false
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                for object in searchResult {
                    context.delete(object)
                }
                response = true
            }
            do {
                try context.save() // <- remember to put this :)
            } catch {
                return false
            }
            return response
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /**
     * SortDecriptor
     * Sorting list
     */
    static func OrdenarPor(campos: [String], ascendente: Bool) -> [NSSortDescriptor]{
        var sorts = [NSSortDescriptor]()
        if(campos.count > 0){
            for campo in campos {
               sorts.append(NSSortDescriptor(key: campo, ascending: ascendente))
            }
        }
        return sorts
    }
    
    
    /**
     * Predicados
     * Lista de funciones para utilizar como predicados
     */
    
    static func Donde(campo: String, contiene texto: String, caseSensitive: Bool) ->NSPredicate{
        if caseSensitive {
            return NSPredicate(format: "%K CONTAINS %@", campo, texto)
        }else{
            return NSPredicate(format: "%K CONTAINS[c] %@", campo, texto)
        }
        
    }
    
    static func Donde(campo: String, es esto: String) ->NSPredicate{
        return NSPredicate(format: "%K == %@", campo, esto)
    }
    
    static func Donde(campo: String, esta activo: Int64) ->NSPredicate{
        return NSPredicate(format: "%K == %@", campo, activo)
    }
    
    static func agruparOR(predicates: [NSPredicate]) ->NSPredicate {
        let retornar = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        return retornar
    }
    
    static func agruparAND(predicates: [NSPredicate]) ->NSPredicate {
        let retornar = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return retornar
    }
    
    static func Ignorar(en campo: String, esto: String) ->NSPredicate{
        return NSPredicate(format: "NOT %K BEGINSWITH %@", campo, esto)
    }
    
    static func DoceHorasAtras() ->NSPredicate{
        //El intervalo de tiempo se realiza en segundos
        let twelveHoursAgo = Date().addingTimeInterval(-43200)
        return NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
    }
    
    static func DesdeHasta(campoFecha: String, desde: Date, hasta: Date) ->NSPredicate{
        
        return NSPredicate(
            format: "%K > %@ AND %K < %@",
            campoFecha, desde as NSDate,
            campoFecha, hasta as NSDate
        )
    }
    
    static func EmpiezaCon(campo: String, texto: String) ->NSPredicate{
        return NSPredicate(format: "%K BEGINSWITH %@", campo, texto)
    }
    
    static func TerminaCon(campo: String, texto: String) ->NSPredicate{
        return NSPredicate(format: "%K ENDSWITH %@", campo, texto)
    }
    
    static func CoincidenciaDe(campo: String, con regExp: String) ->NSPredicate{
        return NSPredicate(format: "%K MATCHES %@", campo, regExp)
    }
    
    static func ComponerPredicado(camposPredicados: [String:String]) ->NSPredicate?{
        if(camposPredicados.count <= 0){
            return nil
        }
        //FALTA TERMINAR ESTA PARTE
        return nil
    }
    
    
    static func truncar( tabla: String ) -> Bool{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: tabla)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try CoreDataStack.managedObjectContext.execute(request)
            CoreDataStack.saveContext()
            return true
        } catch {
            return false
        }
    }
//    static func SoloStrings(){
//        let objects = ["hip", 2, "", "hip", "ss"] as [Any]
//        
//        let removeNonStrings = NSPredicate { (evaluatedObject, _) in
//            return evaluatedObject.isKindOfClass(NSString)
//        }
//        
//        let hipHipArray = (objects as NSArray).filteredArrayUsingPredicate(removeNonStrings)
//        
//    }
    
    
//    static func adsad() -> NSPredicate{
//        return NSPredicate(format: "name contains[c] %@ AND nickName contains[c] %@", argumentArray: [name, nickname])
//        return NSPredicate(format: "name = %@ AND nickName = %@", argumentArray: [name, nickname])
//    }
    
    
    
}
