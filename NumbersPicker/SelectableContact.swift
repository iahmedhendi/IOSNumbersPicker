//
//  SelectableContact.swift
//  SafaSms
//
//  Created by Hendi on 8/1/18.
//  Copyright © 2018 Hendi. All rights reserved.
//

import Foundation
import Contacts
struct SelectableContact {
    var contact: CNContact
    var phoneNumbers: [SelectablePhone]
    init(contact: CNContact, phoneNumbers: [SelectablePhone]) {
        self.contact = contact
        self.phoneNumbers = phoneNumbers
        for c in contact.phoneNumbers {
            self.phoneNumbers.append(SelectablePhone(number: c.value.stringValue, selected: false))
        }

    }
}
