//
//  JSONObject.swift
//
//
//  Created by Sulthan on 07/05/24.
//

import Foundation

public class JSONObject: NSObject, NSFastEnumeration {
    
    var mData: NSMutableDictionary?
    var JSONOBJECT_NULL_VALUE = ""
    
    override init() {
        super.init()
        mData = NSMutableDictionary()
    }
    
    init(capacity: Int) {
        super.init()
        mData = NSMutableDictionary(capacity: capacity)
    }
    
    init(dictionary: NSMutableDictionary) {
        super.init()
        mData = dictionary
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
            if let jsonDict = jsonObject as? NSDictionary {
                if jsonDict.count == 0 {
                    mData = NSMutableDictionary(dictionary: jsonDict)
                } else {
                    mData = jsonDict as? NSMutableDictionary
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

    func description() -> String? {
        return toString()
    }

    func put(_ key: String?,value: Any?) {
        setObject(value, key: key)
    }

    func setObject(_ value: Any?, key: String?) {
        
        if key == nil {
            return
        }
        
        var value = value
        if value == nil {
            value = NSNull()
        }
        
        if value is JSONObject || value is JSONArray {
            if let valueData = value as? JSONObject{
                mData?.setObject(valueData.getData() ?? JSONObject(), forKey: (key as? NSCopying)!)
            } else if let valueData = value as? JSONArray {
                mData?.setObject(valueData.getData() ?? JSONArray(), forKey: (key as? NSCopying)!)
            }
        } else {
            mData?.setObject(value ?? Any.self, forKey: (key as? NSCopying)!)
        }
    }
    
    func getData() -> Any? {
        return mData
    }
    
    func putBool(_ key: String?,_ value: Bool?) {
        
        if key == nil {
            return
        }
        
        mData?[key ?? ""] = NSNumber(value: value ?? true)
    }
    
    func putInt(_ key: String?,_ value: Int?) {
        
        if key == nil {
            return
        }
        
        mData?[key ?? ""] = NSNumber(value: value ?? 0)
    }
    
    func putDouble(_ key: String?,_ value: Double?) {
        
        if key == nil {
            return
        }
        
        mData?[key ?? ""] = NSNumber(value: value ?? 0)
    }
    
    func objectForKey(_ key: String?) -> Any? {
        
        if key == nil {
            return nil
        }
        
        let value = mData?.object(forKey: key ?? "")
        return value is NSNull ? nil : value
        
    }
    
    func get(_ key: String?) -> Any?{
        
        if key == nil {
            return nil
        }
        return objectForKey(key)
    }
    
    func getJSONObject(_ key: String?) -> JSONObject? {
        
        if key == nil {
            return nil
        }
        
        let obj = objectForKey(key)
        
        if obj is NSDictionary {
            return JSONObject.init(dictionary: obj as? NSMutableDictionary ?? [:])
        }else {
            return obj as? JSONObject
        }
        
    }
    
    func getJSONArray(_ key: String?) -> JSONArray?{
        if key == nil {
            return nil
        }
        
        let obj = objectForKey(key ?? "")
        if obj is NSArray {
            return JSONArray(array: obj as? NSMutableArray ?? [])
        } else {
            return obj as? JSONArray
        }
    }
    
    func getBool(_ key: String?) -> Bool? {
        
        if key == nil {
            return false
        }
        
        let obj = objectForKey(key ?? "")
        if obj is NSNumber {
            return (obj as? NSNumber)?.boolValue ?? false
        }
        return false
    }
    
    func getString(_ key: String?) -> String? {
        
        if key == nil {
            return nil
        }
        
        let obj = objectForKey(key ?? "")
        if obj is NSNumber {
            return (obj as AnyObject).stringValue ?? ""
        } else if obj is NSString {
            return obj as? String
        } else if JSONSerialization.isValidJSONObject(obj ?? Any.self) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: obj ?? Any.self, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                } else {
                    return nil
                }
            } catch {
                print("JSONObject : getString : Error: \(error)")
                return nil
            }
        } else {
            return obj.debugDescription
        }
    }
    
    func optString(_ key: String?)-> String?{
        return getString(key ?? "")
    }
    
    func optString(_ key: String?, defaultValue: String?) -> String {
        let val = getString(key)
        if val == nil {
            return defaultValue ?? ""
        } else {
            return val ?? ""
        }
    }
    
    func toJSONArray(_ names: JSONArray?) -> JSONArray?  {
        
        if names == nil || names?.count() == 0 {
            return nil
        }
        
        let ja = JSONArray()
        for i in 0..<(names?.count() ?? 0) {
            if let name = names?.get(i) {
                ja.put(name)
            }
        }
        return ja
    }
    
    func allKeys() -> NSArray? {
        return mData?.allKeys as? NSArray
    }
    
    func names() -> JSONArray? {
        return JSONArray(array: mData?.allKeys as? NSMutableArray ?? [])
    }
    
    func keyEnumerator() -> NSEnumerator? {
        return mData?.keyEnumerator()
    }
    
    func removeAllObjects() {
        mData?.removeAllObjects()
    }
    
    func has(_ key: String?) -> Bool? {
        return mData?.object(forKey: key ?? "") != nil
    }
    
    func remove(_ key: String?) {
        mData?.removeObject(forKey: key ?? "")
    }
    
    func count() -> Int? {
        return mData?.count
    }
    
    public func countByEnumerating(with state: UnsafeMutablePointer<NSFastEnumerationState>, objects stackbuf: AutoreleasingUnsafeMutablePointer<AnyObject?>, count len: Int) -> Int {
        return mData?.countByEnumerating(with: state, objects: stackbuf, count: len) ?? 0
    }
    
    

}
