//
//  Network.swift
//  CenfoWebAPICaller
//
//  Created by user195672 on 6/20/21.
//

import Foundation
protocol NetworkGeneric {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void)
    func put<T: Codable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<Int, ApiError>) -> Void)
    func delete(with request: URLRequest, completion: @escaping (Result<Int,ApiError>) -> Void)
}

extension NetworkGeneric {
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, complete:@escaping (Result<T, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            
            guard let data = data else {
                complete(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let genericModel = try decoder.decode(T.self, from: data)
                complete(.success(genericModel))
            }catch let error {
                complete(.failure(.jsonConvertFailure(description: error.localizedDescription)))
            }
        }
        return task
    }
    private func putTask<T: Codable>(with request: URLRequest, encodingType: T.Type, complete:@escaping (Result<Int, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            
            
     complete(.success(200))

        }
        return task
    }
    private func deleteTask(with request: URLRequest, complete:@escaping (Result<Int, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            
            
     complete(.success(200))

        }
        return task
    }
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    func put<T: Codable>(type: T.Type, with request: URLRequest, completion: @escaping (Result<Int, ApiError>) -> Void) {
        let task = putTask(with: request, encodingType: T.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    func delete(with request: URLRequest, completion: @escaping (Result<Int, ApiError>) -> Void) {
        let task = deleteTask(with: request) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
