//
//  JSONArray.swift
//  
//
//  Created by Sulthan on 07/05/24.
//

import Foundation

class JSONArray: NSObject {
    
    var mData: NSMutableArray?
    
    override init() {
        super.init()
        mData = NSMutableArray()
    }
    
    init(capacity: Int) {
        super.init()
        mData = NSMutableArray(capacity: capacity)
    }
    
    init(array: NSMutableArray) {
        super.init()
        mData = array
    }
    
    convenience init(jsonString: String) {
        self.init(jsonString: jsonString,error: nil)
    }
    
    init(jsonString: String?, error: NSError?) {
        super.init()
        
        guard let jsonData = jsonString?.data(using: .utf8) else {
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            if let jsonArray = jsonObject as? NSArray {
                if jsonArray.count == 0 {
                    mData = NSMutableArray(array: jsonArray)
                } else {
                    mData = jsonArray as? NSMutableArray
                }
            } else {
                throw NSError(domain: "Cueme", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON: Failed to parse JSONObject: \(String(describing: jsonString))"])
            }
        } catch {
             print(NSError(domain: "Cueme", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON string: \(String(describing: jsonString))"]))
        }
    }
    
    func toString() -> String {
        
        guard let data = mData else {
            return ""
        }
                
        guard JSONSerialization.isValidJSONObject(data) else {
            print("mData contains invalid JSON data: \(String(describing: data))")
            return ""
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: [])
            
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Unable to convert data to string")
                return ""
            }
            
            return jsonString
        } catch {

            print("Error during JSON serialization: \(error)")
            return ""
        }
    }

    
    func getData() -> Any? {
        return mData
    }
    
    func count() -> Int? {
        return mData?.count
    }
    
    func put(_ value: Any?) {
        
        if value == nil {
            return
        }
        
        if value is JSONObject || value is JSONArray {
            if let valueData = value as? JSONObject{
                mData?.add(valueData.getData() ?? [:])
            } else if let valueData = value as? JSONArray {
                mData?.add(valueData.getData() ?? [])
            }
    
        } else {
            mData?.add(value ?? Any.self)
        }
    }
    
    func addObject(_ value: Any?) {
        
        if value == nil {
            return
        }
        
        if value is JSONObject || value is JSONArray {
            if let valueData = value as? JSONObject{
                mData?.add(valueData.getData() ?? [:])
            } else if let valueData = value as? JSONArray {
                mData?.add(valueData.getData() ?? [])
            }
        } else {
            mData?.add(value ?? Any.self)
        }
    }
    
    func objectAtIndex(_ index: Int?) -> Any? {
        return mData?.object(at: index ?? 0)
    }
    
    func get(_ index: Int?) -> Any?{
        return mData?.object(at: index ?? 0)
    }
    
    func getJSONObject(_ index: Int?) -> JSONObject? {
        let obj = mData?.object(at: index ?? 0)
        if obj is NSDictionary {
            return JSONObject(dictionary: obj as? NSMutableDictionary ?? [:])
        }
        return nil
    }
    
    func getJSONArray(_ index: Int?) -> JSONArray?{
        let obj = mData?.object(at: index ?? 0)
        if obj is NSArray {
            return JSONArray(array: obj as? NSMutableArray ?? [])
        }
        return nil
    }
    
    func containsObject(_ obj: Any?) -> Bool? {
        return mData?.contains(obj ?? Any.self)
    }
    
    func has(_ obj: Any?) -> Bool? {
        return mData?.contains(obj ?? Any.self)
    }
    
    func removeAllObjects() {
        mData?.removeAllObjects()
    }
    
    func removeObjectAtIndex(_ index: Int?) {
        mData?.removeObject(at: index ?? 0)
    }
   
}

