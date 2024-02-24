//
//  URLSession+extension.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 24.02.24.
//

import Foundation

extension URLSession {
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let error = NetworkError.httpStatusCode(statusCode)
                    ErrorPrinterService.shared.printToConsole(error)
                    fulfillCompletionOnTheMainThread(.failure(error))
                }
            } else if let error {
                let error = NetworkError.urlRequestError(error)
                ErrorPrinterService.shared.printToConsole(error)
                fulfillCompletionOnTheMainThread(.failure(error))
            } else {
                let error = NetworkError.urlSessionError
                ErrorPrinterService.shared.printToConsole(error)
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                let parser = DataParser()
                do {
                    let decoded: T = try parser.parse(data: data)
                    completion(.success(decoded))
                } catch {
                    ErrorPrinterService.shared.printToConsole(error)
                    debugPrint("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                ErrorPrinterService.shared.printToConsole(error)
                completion(.failure(error))
            }
        }
        return task
    }
}
