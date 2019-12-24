//
//  EksiAPI.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Moya

enum EksiAPI {
    case homepage(pageNumber: Int)
    case me(username: String)
    case getLatestEntries(username: String)
    case message
    case heading(url: String, isWithoutDate: Bool, focusTo: String, pageNumber: String?, isQuery: Bool)
    case entry(number: String)
    case search(query: String)
    case sendEntry(model: NewEntryModel)
}

extension EksiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://eksisozluk.com")!
    }
    
    var path: String {
        switch self {
        case .homepage(let number):
            return "/basliklar/bugun/\(number)"
        case .me(let username):
            return "/biri/\(username)"
        case .getLatestEntries(let username):
            return "/basliklar/istatistik/\(username)/son-entryleri"
        case .message:
            return ""
        case .heading(let url, _, _, _, let isQuery):
            if isQuery {
                return "/"
            } else {
                let removedParamUrl = url.split(separator: "?").first!
                return String(removedParamUrl)
            }
        case .entry(let number):
            return "/entry/\(number)"
        case .search:
            return "/autocomplete/query"
            
        case .sendEntry:
            return "/entry/ekle"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homepage:
            return .get
        case .me:
            return .get
        case .getLatestEntries:
            return .get
        case .message:
            return .get
        case .heading:
            return .get
        case .entry:
            return .get
        case .search:
            return .get
        case .sendEntry:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .homepage:
            return .requestPlain
        case .me:
            return .requestPlain
        case .getLatestEntries:
            return .requestPlain
        case .message:
            return .requestPlain
        case .heading(let url, let isWithoutDate, let focusTo, let pageNumber, let isQuery):
            if isQuery {
                let path = url.split(separator: "=").last ?? ""
                let param = String(path)
                return .requestParameters(parameters: ["q": param], encoding: NoURLEncoding())
            } else {
                if isWithoutDate {
                    if let pageNumber = pageNumber {
                        return .requestParameters(parameters: ["p": pageNumber], encoding: URLEncoding.default)
                    } else {
                        return .requestParameters(parameters: ["focusto": focusTo], encoding: URLEncoding.default)
                    }
                    
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter.string(from: Date())
                    if let pageNumber = pageNumber {
                        return .requestParameters(parameters: ["day": dateString, "p": pageNumber], encoding: URLEncoding.default)
                    } else {
                        return .requestParameters(parameters: ["day": dateString], encoding: URLEncoding.default)
                    }
                }
            }
        case .entry:
            return .requestPlain
        case .search(let query):
            return .requestParameters(parameters: ["q": query], encoding: NoURLEncoding())
        case .sendEntry(let model):
            return .requestParameters(parameters: ["Content": model.text,
                                                   "Title": model.title,
                                                   "ReturnURL": model.returnUrl,
                                                   "Id": model.id,
                                                   "__RequestVerificationToken": model.token], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .search, .sendEntry:
            return ["X-Requested-With": "XMLHttpRequest"]
        default:
            return nil
        }
    }
}
