//
//  EksiAPI.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Moya

enum EksiAPI {
    case homepage
    case otherPage(pageNumber: Int)
    case me
    case message
    case heading(url: String)
    case entry
}

extension EksiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://eksisozluk.com")!
    }
    
    var path: String {
        switch self {
        case .homepage:
            return "/basliklar/bugun/1"
        case .otherPage(let pageNumber):
            return "/basliklar/bugun/\(pageNumber)"
        case .me:
            return ""
        case .message:
            return ""
        case .heading(let url):
            return url
        case .entry:
            return ""
        }
    }
    
    var method: Method {
        switch self {
        case .homepage:
            return .get
        case .otherPage:
            return .get
        case .me:
            return .get
        case .message:
            return .get
        case .heading:
            return .get
        case .entry:
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
        case .otherPage:
            return .requestPlain
        case .me:
            return .requestPlain
        case .message:
            return .requestPlain
        case .heading:
            return .requestPlain
        case .entry:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [ "X-Requested-With": "XMLHttpRequest",
                 "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Safari Line/9.12.0",
                 "Accept-Language": "tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7,ru;q=0.6",
                 "Accept-Encoding": "gzip, deflate, br"]
    }
    
    
}
