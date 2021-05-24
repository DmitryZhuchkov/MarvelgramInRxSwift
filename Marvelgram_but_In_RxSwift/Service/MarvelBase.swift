//
//  MarvelBase.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import Foundation

class MarvelBase {
    static let base = MarvelBase()
    let decoder = JSONDecoder()
    
    
    // MARK: Network layer
    public func fetchHeroes(params: [String: String]? = nil,successHandler: @escaping (_ response: [MarvelJSON]) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
        
        guard let url = URL(string: Config.shared.url) else {return}
        let request = URLRequest(url: url)
          
        URLSession.shared.dataTask(with: request) { (data, response, error) in
              if error != nil {
                  self.handleError(errorHandler: errorHandler, error: InternetError.apiError)
                  return
              }
              
              guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                  self.handleError(errorHandler: errorHandler, error: InternetError.invalidResponse)
                  return
              }
              
              guard let data = data else {
                  self.handleError(errorHandler: errorHandler, error: InternetError.noData)
                  return
              }
              
              do {
                
                  let heroesResponse = try JSONDecoder().decode([MarvelJSON].self, from: data)
                  DispatchQueue.main.async {
                      successHandler(heroesResponse)
                  }
              } catch {
                print(error)
                  self.handleError(errorHandler: errorHandler, error: InternetError.serializationError)
              }
          }.resume()
          
      }
    
    // MARK: Network error handler
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
          DispatchQueue.main.async {
              errorHandler(error)
          }
      }
    
    // MARK: Errors enum
    enum InternetError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case serializationError
    }
}
