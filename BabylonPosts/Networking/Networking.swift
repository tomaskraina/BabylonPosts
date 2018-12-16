//
//  Networking.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

// TODO: Reimplement Networking without using Alamofire
import Alamofire
import CodableAlamofire
import RxSwift

// MARK: - Networking

class Networking: NetworkingType {
    
    static let shared = Networking(manager: .default)
    
    init(manager: SessionManager) {
        self.manager = manager
    }
    
    let manager: SessionManager
    
    let activityTracker = ActivityTracker()
    
    @discardableResult
    func request<T: Decodable>(endpoint: Endpoint) -> Single<T> {
        
        // TODO: Configure retry logic (e.g. max X times every Y seconds if request times out)
        return Single<T>.create { [manager] handler in
            let dataRequest = manager.request(endpoint, method: endpoint.method, parameters: endpoint.parameters)
            dataRequest.responseDecodableObject { (dataResponse: DataResponse<T>) in
                
                switch dataResponse.result {
                case .success(let value):
                    handler(.success(value))
                    
                case .failure(let error):
                    let networkingError = NetworkingError.init(error: error, httpUrlResponse: dataResponse.response)
                    handler(.error(networkingError))
                }
                
            }
            
            dataRequest.resume()
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }.trackActivity(activityTracker).asSingle()
    }
    
    var isLoading: Observable<Bool> {
        return activityTracker.asObservable()
    }
}
