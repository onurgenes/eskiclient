//
//  NetworkManager.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Moya
import Kanna

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
                    
                    // Checking is logged in with all request
                    let doc = try? HTML(html: finalValue, encoding: .utf8)
                    let loggedInTag = doc?.xpath("//*[@id='top-login-link']").first?.content
                    let isLoggedIn = loggedInTag != nil ? false : true
                    if isLoggedIn {
                        if let username = doc?.xpath("//*[@id='top-navigation']/ul/li[6]/a/@href").first?.content {
                            let username = username.split(separator: "/").last
                            UserDefaults.standard.set(username, forKey: "currentUsername")
                        }
                        
                    }
                    NotificationCenter.default.post(name: .loginNotificationName, object: nil, userInfo: ["isLoggedIn": isLoggedIn])
                    
                    completion(.success(finalValue))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchModel<T: Decodable>(_ eksiAPI: EksiAPI, completion: @escaping(Result<T, Error>)->()) {
        client.session.sessionConfiguration.httpCookieStorage?.setCookies(CookieJar.retrive(), for: URL(string: "https://eksisozluk.com"), mainDocumentURL: nil)
        client.request(eksiAPI) { result in
            switch result {
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    if let headerFields = value.response?.allHeaderFields as? [String: String],
                        let URL = value.request?.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                        CookieJar.save(cookies: cookies)
                    }
                    let filteredResponse = try value.filterSuccessfulStatusCodes()
                    let model = try decoder.decode(T.self, from: filteredResponse.data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getHomePage(number: Int, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.homepage(pageNumber: number)) { completion($0) }
    }
    
    func getHeading(url: String, isWithoutDate: Bool, focusTo: String, pageNumber: String?, isQuery: Bool, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.heading(url: url, isWithoutDate: isWithoutDate, focusTo: focusTo, pageNumber: pageNumber, isQuery: isQuery)) { completion($0) }
    }
    
    func getEntry(number: String, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.entry(number: number)) { completion($0) }
    }
    
    func getMe(username: String, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.me(username: username)) { completion($0) }
    }
    
    func getLatestEntries(username: String, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.getLatestEntries(username: username)) { completion($0) }
    }
    
    func search(query: String, completion: @escaping (Result<SearchModel, Error>) -> ()) {
        client.request(.search(query: query)) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let respose):
                do {
                    let value = try respose.filterSuccessfulStatusCodes()
                    let model = try JSONDecoder().decode(SearchModel.self, from: value.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
                
            }
        }
    }
    
    func vote(model: Entry, isUpVote: Bool, completion: @escaping (Result<VoteResultModel, Error>) -> ()) {
        fetchModel(.vote(model: model, isUpVote: isUpVote)) { completion($0) }
    }
    
    func fav(entryId: String, completion: @escaping (Result<FavResultModel, Error>) -> ()) {
        fetchModel(.fav(entryId: entryId)) { completion($0) }
    }
    
    func removeFav(entryId: String, completion: @escaping (Result<FavResultModel, Error>) -> ()) {
        fetchModel(.removeFav(entryId: entryId)) { completion($0) }
    }
    
    func sendEntry(model: NewEntryModel, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.sendEntry(model: model)) { completion($0) }
    }
    
    func getMessages(page: Int = 1, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.getMessages(page: page)) { completion($0) }
    }
    
    func getMessageDetails(threadId: Int, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.getMessageDetails(id: threadId)) { completion($0)}
    }
    
    func sendMessage(model: NewMessageModel, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.sendMessage(model: model)) { completion($0) }
    }
}
