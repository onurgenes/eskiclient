//
//  CookieJar.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

final class CookieJar {
    
    static let cookiesKey = "cookiesKey"
    
    static func save(cookies: [HTTPCookie]) {
        let cookieDict = UserDefaults.standard.dictionary(forKey: cookiesKey)
        var newDict = [String: Any]()
        if let dict = cookieDict { newDict = dict }
        for cookie in cookies {
            newDict[cookie.name] = cookie.properties as AnyObject
        }
        UserDefaults.standard.set(newDict, forKey: cookiesKey)
    }
    
    static func retrive() -> [HTTPCookie] {
        var cookies = [HTTPCookie]()
        if let cookieDictionary = UserDefaults.standard.dictionary(forKey: cookiesKey) {
            for (_, cookieProperties) in cookieDictionary {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    cookies.append(cookie)
                }
            }
        }
        return cookies
    }
}
