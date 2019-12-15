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
    case entry
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
        case .entry:
            return ""
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
                return .requestParameters(parameters: ["q": param], encoding: NOURLEncoding())
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
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

import Alamofire
public struct NOURLEncoding: ParameterEncoding {
    
    //protocol implementation
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        guard let url = urlRequest.url else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
    
    //append query parameters
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    //Alamofire logic for query components handling
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    //escaping function where we can select symbols which we want to escape
    //(I just removed + for example)
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        
        return escaped
    }
    
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
