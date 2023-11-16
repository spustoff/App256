//
//  SignalsViewModel.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI
import CoreData
import Alamofire

final class SignalsViewModel: ObservableObject {
    
    @Published var isAdd: Bool = false
    @Published var isRisks: Bool = false
    @Published var isLoading: Bool = false
    @Published var isComparison: Bool = false
    
    @Published var selectedComparison: Int = 1
    
    @Published var signals: [SignalsItem] = []
    @Published var coreSignals: [SignalsCoreModel] = []
    
    @Published var comparison_first: SignalsItem = SignalsItem(resultHash: "", resultInstrument: "", resultPeriod: "", resultTp: 0, resultSl: 0, resultP: 0, resultSignal: "", resultDate: "")
    @Published var comparison_second: SignalsItem = SignalsItem(resultHash: "", resultInstrument: "", resultPeriod: "", resultTp: 0, resultSl: 0, resultP: 0, resultSignal: "", resultDate: "")
    
    @AppStorage("saved_signals") var saved_signals: [String] = []
    @AppStorage("risks_signals") var risks_signals: [String] = []
    
    @Published var name: String = ""
    @Published var buy: String = ""
    @Published var sell: String = ""
    @Published var stop_loss: String = ""
    @Published var take_profit: String = ""
    @Published var duration: String = ""
    
    @Published var durations: [String] = ["1M", "5M", "10M", "15M", "Other"]
    
    func fetchCoreSignals() {
        
        CoreDataStack.shared.modelName = "SignalsCoreModel"
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<SignalsCoreModel>(entityName: "SignalsCoreModel")

        do {
            
            let branch = try context.fetch(fetchRequest)
            
            self.coreSignals = branch
            
        } catch let error as NSError {
            
            print("Error fetching persons: \(error), \(error.userInfo)")
            
            self.coreSignals = []
        }
    }
    
    func addSignal(completion: @escaping () -> (Void)) {
        
        CoreDataStack.shared.modelName = "SignalsCoreModel"
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let trans = NSEntityDescription.insertNewObject(forEntityName: "SignalsCoreModel", into: context) as! SignalsCoreModel
        
        trans.name = name
        trans.buy = Int16(buy) ?? 0
        trans.sell = Int16(sell) ?? 0
        trans.stop_loss = Int16(stop_loss) ?? 0
        trans.take_profit = Int16(take_profit) ?? 0
        trans.duration = duration
        
        CoreDataStack.shared.saveContext()
        
        completion()
    }
    
    func getSignals() {
        
        isLoading = true
        
        self.fetchSignals() { result in
            
            switch result {
                
            case .success(let success):
                
                self.signals = success.results
                
            case .failure(let failure):
                
                debugPrint("Parse error - \(failure)")
                
                self.isLoading = false
            }
        }
    }
    
    func fetchSignals(completion: @escaping (Result<SignalsModel, Error>) -> Void ) {
        
        isLoading = true
        
        let params: Parameters = [
            
            "token": "aeb64ef3-3157-439a-8cce-7972921ec9fc",
        ]
        
        let request = AF.request("https://kasuterd.space/api/v2/signals", method: .get, parameters: params)
        
        request.responseDecodable(of: SignalsModel.self) { response in
            
            guard let value = response.value else {
                
                self.isLoading = false
                return
            }
                           
            switch response.result{
                
            case .success(_):
                
                completion(.success(value))
                self.isLoading = false
                
            case .failure(_):
                
                completion(.failure(response.error.debugDescription as! Error))
                self.isLoading = false
            }
        }
    }
}
