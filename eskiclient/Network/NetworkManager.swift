//
//  NetworkManager.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Moya
import Kanna
import Alamofire

final class NetworkManager: Networkable {
    
    var client: MoyaProvider<EksiAPI> = {
        #if DEBUG
        var config = NetworkLoggerPlugin.Configuration()
        config.logOptions = .verbose
        let logger = NetworkLoggerPlugin(configuration: config)
        return MoyaProvider<EksiAPI>(plugins: [logger])
        #else
        return MoyaProvider<EksiAPI>()
        #endif
    }()
    
    func fetch(_ targetAPI: EksiAPI, completion: @escaping(Result<String, Error>)->()) {
        // Set cookies for session management
        client.session.sessionConfiguration.httpCookieStorage?.setCookies(CookieJar.retrive(), for: URL(string: "https://eksisozluk.com"), mainDocumentURL: nil)
        client.request(targetAPI) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                do {
                    if let headerFields = value.response?.allHeaderFields as? [String: String],
                        let URL = value.request?.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                        CookieJar.save(cookies: cookies)
                    }
                    let filteredResponse = try value.filterSuccessfulStatusCodes()
                    let finalValue = try filteredResponse.mapString()
                    completion(.success(finalValue))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getLanding(completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.landing) { completion($0) }
    }
    
    func getHomePage(number: Int, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.homepage(pageNumber: number)) { completion($0) }
    }
    
    func getHeading(url: String, isWithoutDate: Bool, focusTo: String, pageNumber: String?, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.heading(url: url, isWithoutDate: isWithoutDate, focusTo: focusTo, pageNumber: pageNumber)) { completion($0) }
    }
}
