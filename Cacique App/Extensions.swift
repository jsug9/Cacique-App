//
//  FileManagerExtension.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import Foundation

let fileName = "Orders3.json"

extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveDocument(contents: String, docName: String, completion: (OrderError?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            completion(.saveError)
        }
    }
    
    func readDocument(docName: String, completion: (Result<Data, OrderError>) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(.readError))
        }
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Double {
    func currencyPEN() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "S/."
        
        return formatter.string(from: NSNumber(value: self)) ?? "ERROR"
    }
    
    func twoDecimals() -> String {
        String(format: "%.2f", self)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
