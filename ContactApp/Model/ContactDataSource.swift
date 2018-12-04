//
//  ContactDataSource
//  ContactApp
//
//  Created by Anil Telaich on 30/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import Foundation


/// Class encapsulates a contact info.
class ContactItem {
    let firstName : String
    let lastName : String
    let title : String
    let introduction : String
    let avtarFileName : String
    
    init(contactItemAsDictionary : Dictionary<String, Any>) {
        self.firstName = contactItemAsDictionary["first_name"] as! String
        self.lastName = contactItemAsDictionary["last_name"] as! String
        self.title = contactItemAsDictionary["title"] as! String
        self.introduction = contactItemAsDictionary["introduction"] as! String
        self.avtarFileName = contactItemAsDictionary["avatar_filename"] as! String
    }
}


/// A class that will be a Contact data source.
/// Its a simple class as of now, however this can be extended in future to have any kind of source- DB, JSON a network DB.
/// This class can be made an abstract class and concrete classes can initialize themshelves to connect to appropriate dataSource

class ContactDataSource {
    let dataSourceInfo : Any?
    init(dataSourceInfo: Any?) {
        self.dataSourceInfo = dataSourceInfo
    }
    
    func contactsList() -> [ContactItem] {
        let fileName = "contacts"
        let fileExtension = "json"
        var contacts : [ContactItem] = []
        let jsonFileURL : URL? = Bundle.main.url(forResource:fileName, withExtension:fileExtension)
        if let fileURL = jsonFileURL {
            do {
                // let jsonDataAsPlainText:String? = try String(contentsOf:fileURL)
                let jsonAsData : Data = try Data(contentsOf: fileURL, options:[])
                let jsonObject : Any? = try JSONSerialization.jsonObject(with: jsonAsData, options: [])
                let jsonObjectsArray : Array = jsonObject as! [[String: Any]]
                for jsonObject : Dictionary in jsonObjectsArray {
                    contacts.append(ContactItem(contactItemAsDictionary: jsonObject))
                }
            } catch {
                print("Error parsing contatcts from \(fileName).\(fileExtension).")
            }
        }
        return contacts
    }
}
