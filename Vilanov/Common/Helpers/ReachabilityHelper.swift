//
//  ReachabilityHelper.swift
//  Vilanov
//
//  Created by andres on 2/28/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

public class Accesibilidad {
    
    class func tieneInternet() -> Bool {
        var direccionCero = sockaddr_in()
        direccionCero.sin_len = UInt8(MemoryLayout.size(ofValue: direccionCero))
        direccionCero.sin_family = sa_family_t(AF_INET)
        
        let rutaAccesiblePorDefecto = withUnsafePointer(to: &direccionCero) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var banderas = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(rutaAccesiblePorDefecto!, &banderas) {
            return false
        }
        let esAccesible = (banderas.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let necesitaConexion = (banderas.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (esAccesible && !necesitaConexion)
    }
}

