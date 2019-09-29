//
//  DataLoader.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

let SERVER_URL: String = "http://demo3.echo.vkhackathon.com:8000/"
let REQUEST_FUNDS: String = "get_fonds/"
let REQUEST_WILDPOINTS: String = "get_wildpoints/"
let REQUEST_CREATENEWUSER: String = "create_user/"
let REQUEST_SIGNIN: String = "sign_in/"
let REQUEST_PROFILE: String = "get_user/"
let REQUEST_NEARBYWILDPOINTS: String = "get_animals/"
let REQUEST_CREATEWILDPOINT: String = "set_wildpoint/"

class DataLoader {
    func getFunds (completion:@escaping ((_ result: ResponseFund) -> Void)) {
        var funds = ResponseFund(fonds: [])
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_FUNDS,
                          method: .post,
                          parameters: [:],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        funds = try decoder.decode(ResponseFund.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed get funds")
                            }
                            OperationQueue.main.addOperation {
                                completion(funds)
                            }
        }
    }
    
    func getWildPoints (completion:@escaping ((_ result: ResponceWildPoints) -> Void)) {
        var wildPoints = ResponceWildPoints(wildpoints: [])
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_WILDPOINTS,
                          method: .post,
                          parameters: [:],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data{
                                    do{
                                        let decoder = JSONDecoder()
                                        wildPoints = try decoder.decode(ResponceWildPoints.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed get wildpoints")
                            }
                            OperationQueue.main.addOperation {
                                completion(wildPoints)
                            }
        }
    }
    
    func createNewUser (request: RequestSignUp, completion:@escaping ((_ result: ResponseAuth) -> Void)) {
        var serverResponse = ResponseAuth(user: User(local_id: "", name: "", account: 0, idToken: "", email: ""))
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_CREATENEWUSER,
                          method: .post,
                          parameters: ["user":request.conventParameters()],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        serverResponse = try decoder.decode(ResponseAuth.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed create user account")
                            }
                            OperationQueue.main.addOperation {
                                completion(serverResponse)
                            }
        }
    }
    
    func signIn (request: RequestSignIn, completion:@escaping ((_ result: ResponseAuth) -> Void)) {
        var serverResponse = ResponseAuth(user: User(local_id: "", name: "", account: 0, idToken: "", email: ""))
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_SIGNIN,
                          method: .post,
                          parameters: ["user":request.conventParameters()],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        serverResponse = try decoder.decode(ResponseAuth.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed sign in")
                            }
                            OperationQueue.main.addOperation {
                                completion(serverResponse)
                            }
        }
    }
    
    func getProfile (request: RequestProfile, completion:@escaping ((_ result: ResponseAuth) -> Void)) {
        var serverResponse = ResponseAuth(user: User(local_id: "", name: "", account: 0, idToken: "", email: ""))
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_PROFILE,
                          method: .post,
                          parameters: ["user":request.conventParameters()],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        serverResponse = try decoder.decode(ResponseAuth.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed get profile")
                            }
                            OperationQueue.main.addOperation {
                                completion(serverResponse)
                            }
        }
    }
    
    func createWildPoint (request: RequestCreateWildPoint, completion:@escaping ((_ result: ResponseCreateWildPoint) -> Void)) {
        var serverResponse = ResponseCreateWildPoint(wildpoint: CreatedWildPoint(uid: 0, lon: 0, lat: 0, kind: "", account: 0, owner: ""))
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_CREATEWILDPOINT,
                          method: .post,
                          parameters: ["wildpoint":request.conventParameters()],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        serverResponse = try decoder.decode(ResponseCreateWildPoint.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed create wild point")
                            }
                            OperationQueue.main.addOperation {
                                completion(serverResponse)
                            }
        }
    }
    
    func getNearbyWildPoints (request: RequestNearbyWildPoints, completion:@escaping ((_ result: ResponceWildPoints) -> Void)) {
        var wildPoints = ResponceWildPoints(wildpoints: [])
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_NEARBYWILDPOINTS,
                          method: .post,
                          parameters: ["user":request.conventParameters()],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data{
                                    do{
                                        let decoder = JSONDecoder()
                                        wildPoints = try decoder.decode(ResponceWildPoints.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed get wildpoints")
                            }
                            OperationQueue.main.addOperation {
                                completion(wildPoints)
                            }
        }
    }
}
