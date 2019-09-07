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
    
    func fetch(_ targetAPI: EksiAPI, completion: @escaping(Result<Data, Error>)->()) {
        client.request(targetAPI) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                completion(.success(value.data))
            }
        }
    }
    
    func getHomePage(completion: @escaping (Result<String, Error>) -> ()) {
        client.request(.homepage) { (result) in
            switch result {
            case .failure(let err):
                print(err)
                completion(.failure(err))
            case .success(let val):
                do {
                    let a = try val.mapString()
                    completion(.success(a))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
