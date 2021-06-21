//
//  ClientAPI.swift
//  CenfoWebAPICaller
//
//  Created by user195672 on 6/20/21.
//

import Foundation
class Client: NetworkGeneric {
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get<T: Decodable>(type:T.Type, URI:String ,complete: @escaping (Result<T, ApiError>) -> Void) {

        let url = URL(string: URI)
        let request = URLRequest(url: url!)
        
        self.fetch(type: T.self, with: request, completion: complete)
    }
    func put<T: Codable>(type:T.Type, URI:String ,complete: @escaping (Result<Int, ApiError>) -> Void) {

        let url = URL(string: URI)
        let request = URLRequest(url: url!)
        
        self.put(type: T.self, with: request, completion: complete)
    }
    func delete(URI:String ,complete: @escaping (Result<Int, ApiError>) -> Void) {

        let url = URL(string: URI)
        let request = URLRequest(url: url!)
        
        self.delete( with: request, completion: complete)
    }
    

    func post<T: Codable>(type:T,URI:String, complete:  @escaping (T) -> Void) {
        let url = URL(string: URI)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONEncoder().encode(type)
        request.httpBody = data
        
        self.fetch(type: T.self, with: request) { resut in
            switch resut{
            case .success(let feed):
                complete(feed)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
