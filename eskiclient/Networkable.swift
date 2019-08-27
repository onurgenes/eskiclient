//
//  Networkable.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Moya
import Kanna

protocol Networkable: AnyObject {
    var client: MoyaProvider<EksiAPI> { get set }
    
    typealias ResultHTML = Result<HTMLDocument, Error>
    
    func getHomePage(completion: @escaping (Result<String, Error>) -> ())
}
