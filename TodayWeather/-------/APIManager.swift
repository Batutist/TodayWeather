//
//  APIManager.swift
//  TodayWeather
//
//  Created by Sergey on 12.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletitionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}


protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completitionHandler: @escaping JSONCompletitionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completitionHandler: @escaping (APIResult<T>) -> Void)
    
}

extension APIManager {
    
    func JSONTaskWith(request: URLRequest, completitionHandler: @escaping JSONCompletitionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: LMCNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                
                completitionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completitionHandler(nil, HTTPResponse, error)
                }
            } else {
                
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completitionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completitionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
                
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completitionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let json = json else {
                    if let error = error {
                        completitionHandler(.Failure(error))
                    }
                    return
                }
                
                if let value = parse(json) {
                    completitionHandler(.Success(value))
                } else {
                    let error = NSError(domain: LMCNetworkingErrorDomain, code: 200, userInfo: nil)
                    completitionHandler(.Failure(error))
                }
            })
        }
        dataTask.resume()
    }
    
}









