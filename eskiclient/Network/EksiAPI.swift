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
    case getMessages(page: Int)
    case getMessageDetails(id: Int)
    case sendNewMessage(model: NewMessageModel)
    case heading(url: String, isWithoutDate: Bool, focusTo: String, pageNumber: String?, isQuery: Bool)
    case entry(number: String)
    case search(query: String)
    case sendEntry(model: NewEntryModel)
    case vote(model: Entry, isUpVote: Bool)
    case fav(entryId: String)
    case removeFav(entryId: String)
    case logout
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
        case .getMessages:
            return "/mesaj"
        case .getMessageDetails(let id):
            return "/mesaj/\(id)"
        case .sendNewMessage:
            return "/mesaj/yolla"
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
        case .vote:
            return "/entry/vote"
        case .fav:
            return "/entry/favla"
        case .removeFav:
            return "/entry/favlama"
        case .logout:
            return "/terk"
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
        case .getMessages:
            return .get
        case .getMessageDetails:
            return .get
        case .sendNewMessage:
            return .post
        case .heading:
            return .get
        case .entry:
            return .get
        case .search:
            return .get
        case .sendEntry:
            return .post
        case .vote:
            return .post
        case .fav:
            return .post
        case .removeFav:
            return .post
        case .logout:
            return .get
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
        case .getMessages(let page):
            return .requestParameters(parameters: ["p": page], encoding: NoURLEncoding())
        case .getMessageDetails:
            return .requestPlain
        case .sendNewMessage(let model):
            return .requestParameters(parameters: [ "Message": model.message,
                                                    "IsReply": model.isReply,
                                                    "ThreadId": model.threadId,
                                                    "__RequestVerificationToken": model.token,
                                                    "To": model.to], encoding: URLEncoding.default)
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
        case .vote(let model, let isUpVote):
            return .requestParameters(parameters: ["owner": model.authorId,
                                                   "id": model.entryId,
                                                   "rate": isUpVote ? "1" : "-1"], encoding: URLEncoding.default)
        case .fav(let entryId):
            return .requestParameters(parameters: ["entryId": entryId], encoding: URLEncoding.default)
        case .removeFav(let entryId):
            return .requestParameters(parameters: ["entryId": entryId], encoding: URLEncoding.default)
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .search, .sendEntry, .vote, .fav, .removeFav, .sendNewMessage:
            return ["X-Requested-With": "XMLHttpRequest"]
        default:
            return nil
        }
    }
}
