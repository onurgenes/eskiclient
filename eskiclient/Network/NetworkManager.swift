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
        var config = NetworkLoggerPlugin.Configuration()
        config.logOptions = .verbose
        let logger = NetworkLoggerPlugin(configuration: config)
        return MoyaProvider<EksiAPI>(plugins: [logger])
    }()
    
    func fetch(_ targetAPI: EksiAPI, completion: @escaping(Result<String, Error>)->()) {
        client.request(targetAPI) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                do {
                    let filteredResponse = try value.filterSuccessfulStatusCodes()
                    let finalValue = try filteredResponse.mapString()
                    completion(.success(finalValue))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getHomePage(completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.homepage) { completion($0) }
    }
    
    func getHeading(url: String, completion: @escaping (Result<String, Error>) -> ()) {
        fetch(.heading(url: url)) { completion($0) }
    }
}
