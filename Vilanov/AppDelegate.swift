//
//  AppDelegate.swift
//  Vilanov
//
//  Created by Daniel on 24/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SwiftDate
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window                  : UIWindow?
    let gcmMessageIDKey         = "gcm.message_id"
    let notificationDelegate    = SampleNotificationDelegate()
//    var notificacionesDelegate  = NotificacionesDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configureFirebaseInApp(application: application, didFinishLaunchingWithOptions: launchOptions)
//        self.scheduleNotification(at: Date())
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.saveContext()
    }
    
// MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GeaBenefits")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - CORE DATA FOR NOTIFICATIONS
    func saveNewNotification(entidad: CDNotification, item: NotificationModel) {
        let date = item.fecha.toDate("yyyy-MM-dd", region: .local)
        let year = "\(date!.year)"
        let month = "\(date!.month)"
        entidad.fehca       = item.fecha
        entidad.descripcion = item.descripcion
        entidad.titulo      = item.titulo
        entidad.tipo        = item.tipo
        entidad.anio        = year
        entidad.mes         = month
        entidad.activo      = item.activo
        entidad.id_noticia  = item.id_noticia
        entidad.tipo_noticia = item.tipo_noticia
        let resultado = CoreDataStack.saveContextBool() ? "noticia:\(item.id_noticia) tipo:\(item.tipo_noticia)" : "#\(item.id_noticia) NO pudo guardarse."
        print(resultado)
    }
    
    func configureFirebaseInApp(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        self.configureNotification()
        Messaging.messaging().delegate = self
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(false)
        
        if launchOptions != nil {
            //opened from a push notification when the app is closed
            _ = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
        } else {
            print("opened app without a push notification.")
        }
        
        let prefs: UserDefaults = UserDefaults.standard
        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            prefs.set(remoteNotification as! [AnyHashable: Any], forKey: "startUpNotif")
            prefs.synchronize()
        }
        self.connectToFcm()
    }
    
    
    func connectToFcm() {
//        if AppSettings.regId == "" {
            InstanceID.instanceID().instanceID { (instanceIDResult, error) in
                if error != nil {
                    print(error.debugDescription)
                }else {
                    if instanceIDResult != nil {
//                        print("INSTANCE ID:")
//                        print(instanceIDResult!.instanceID)
//                        print(instanceIDResult!.token)
//                        print(instanceIDResult!.description)
//                        print(instanceIDResult!.debugDescription)
                    }
                }
            }
//        }
    }
    
    
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        self.connectToFcm()
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func scheduleNotification(at date: Date) {
        
        //get the notification center
        let center =  UNUserNotificationCenter.current()
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Reunión"
        content.subtitle = "Está por empezar"
        content.body = "La reunión con el personal de trabajo para coordinar mantenimiento de equipos."
        //            content.sound = UNNotificationSound.default()
        
//        let sound = UNNotificationSound(named: "mario.mp3")
//        content.sound = UNNotificationSound.init(named: sound)
        content.badge = 0
        //        content.userInfo = ["userData": "{\"aps\":{\"alert\":\"Incoming video call from - Bob\",\"badge\":1,\"sound\":\"mario.mp3\",\"userdata\":{\"JSON\": \"asdasd\"}}}"]
        content.userInfo = ["MEETING_ID" : "123123",
                            "USER_ID" : "1" ]
        
        content.categoryIdentifier = "AVISO_CATEGORY"
        if let path = Bundle.main.path(forResource: "logo", ofType: "jpg") {
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        //notification trigger can be based on time, calendar or location
        let trigger     = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)
        let request     = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        let action      = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Recordar más tarde", options: [])
        let action2     = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Abrir otra vista", options: [.foreground])
        let category    = UNNotificationCategory(identifier: "MEETING_INVITATION", actions: [action,action2], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("UNUserNotificationCenter openSettingsFor")
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("***********************************************")
        print("willPresent notification")
        print("***********************************************")
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        var id_noticia = "", tipo_noticia = "", body = "", fecha = "", titulo = "", tipo = ""
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    _ = message as String
                }
                if let title = alert["title"] as? NSString {
                    titulo = title as String
                }
                if let boddy = alert["body"] as? NSString {
                    body = boddy as String
                }
                
            } else if let alert = aps["alert"] as? NSString {
                _ = alert as String
            }
        }
        if let date = userInfo["fecha"] as? String {
            fecha = date
        }

        if let type = userInfo["tipo"] as? String {
            tipo = type
        }
        if let tipo_noticias = userInfo["tipo_noticia"] as? String {
            tipo_noticia = tipo_noticias
        }
        if let id_noticias = userInfo["id_noticia"] as? String {
            id_noticia = id_noticias
        }
        
        let notif = NotificationModel(
            titulo      : titulo,
            descripcion : body,
            tipo        : tipo,
            fecha       : fecha,
            mes         : "",
            anio        : "",
            activo      : "1",
            id_noticia  : id_noticia,
            tipo_noticia: tipo_noticia
        )
        let entidad = CDNotification(context: CoreDataStack.managedObjectContext)
        self.saveNewNotification(entidad: entidad, item: notif)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    //MARK: - Manejo de acciones en una notificacion.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("***********************************************")
        print("didReceive response")
        print("***********************************************")
        let userInfo = response.notification.request.content.userInfo
        //        let userInfoJson = JSON(userInfo)
        //        print(userInfoJson)
        AppSettings.esAviso = true
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: nil, userInfo: userInfo)
        /*
         let categoryIdentifier = response.notification.request.content.categoryIdentifier
         let identifier = response.actionIdentifier
         
         if( categoryIdentifier == "MEETING_INVITATION")  {
         let meetingID = userInfo["MEETING_ID"] as! String
         let userID = userInfo["USER_ID"] as! String
         switch identifier {
         case "ACCEPT_ACTION":
         print("ACCEPT_ACTION: ---\(meetingID)  ---\(userID)")
         break
         case "DECLINE_ACTION":
         print("DECLINE_ACTION: ---\(meetingID)  ---\(userID)")
         break
         default:
         print("alsdjaldjalksjdlaksjdlaljasdlaslkdjalk")
         break
         }
         }else if( categoryIdentifier == "AVISO_CATEGORY" ) {
         AppSettings.esAviso = true
         print("AVISO!!! \(AppSettings.esAviso)")
         LogHelper.printlog(message: "Notificacion CATEGORY", type: LogHelper.warning)
         
         }else {
         print("No hay bolo..")
         }
         */
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        var id_noticia = "", tipo_noticia = "", body = "", fecha = "", titulo = "", tipo = ""
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    _ = message as String
                }
                if let title = alert["title"] as? NSString {
                    titulo = title as String
                }
                if let boddy = alert["body"] as? NSString {
                    body = boddy as String
                }
                
            } else if let alert = aps["alert"] as? NSString {
                _ = alert as String
            }
        }
        if let date = userInfo["fecha"] as? String {
            fecha = date
        }
        
        if let type = userInfo["tipo"] as? String {
            tipo = type
        }
        if let tipo_noticias = userInfo["tipo_noticia"] as? String {
            tipo_noticia = tipo_noticias
        }
        if let id_noticias = userInfo["id_noticia"] as? String {
            id_noticia = id_noticias
        }
        
        let notif = NotificationModel(
            titulo      : titulo,
            descripcion : body,
            tipo        : tipo,
            fecha       : fecha,
            mes         : "",
            anio        : "",
            activo      : "1",
            id_noticia  : id_noticia,
            tipo_noticia: tipo_noticia
        )
        let entidad = CDNotification(context: CoreDataStack.managedObjectContext)
        self.saveNewNotification(entidad: entidad, item: notif)
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppSettings.regId = fcmToken
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data MENSAJE: \(remoteMessage.appData)")
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Received data MENSAJE: "); print(userInfo)
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received data MENSAJE: "); print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Received data MENSAJE: "); print(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func configureNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        center.delegate = notificationDelegate
        let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
        let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories(Set([deafultCategory]))
        UIApplication.shared.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
}

extension UIApplication {
    
    func openAppSettings() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            openExpectedURL(url)
        }
    }
    
    fileprivate func openExpectedURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
