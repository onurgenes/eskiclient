//
//  AppDelegate.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Firebase
import Kanna

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        app.start()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["5221ff4276388f681e7dea644060adaa", kGADSimulatorID as! String]
        if iapObserver.isAuthorizedForPayments {
            SKPaymentQueue.default().add(iapObserver)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let networkManager = NetworkManager()
        networkManager.getMessages { result in
            switch result {
            case .failure(_):
                completionHandler(.failed)
            case .success(let response):
                do {
                    let doc = try HTML(html: response, encoding: .utf8)
                    
                    if let dateString = doc.xpath("//*[@id='threads']/li[1]/article/footer/time/@title").first?.text {
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                        
                        if let oldDate = UserDefaults.standard.object(forKey: "lastMessageDate") as? Date {
                            print(oldDate)
                            let newDate = dateFormatter.date(from: dateString)
                            if newDate != oldDate {
                                
                                let content = UNMutableNotificationContent()
                                content.title = "galiba yeni mesajın var"
                                content.body = "bakmasan da olur ama bi bak istersen"
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                let request = UNNotificationRequest(identifier: "\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                                completionHandler(.newData)
                            } else {
                                completionHandler(.noData)
                            }
                        } else {
                            completionHandler(.failed)
                        }
                    } else {
                        completionHandler(.failed)
                    }
                } catch {
                    completionHandler(.failed)
                }
                
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(iapObserver)
    }
}

