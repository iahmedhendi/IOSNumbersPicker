//
//  SelectContactTableViewController.swift
//  SafaSms
//
//  Created by Hendi on 8/1/18.
//  Copyright © 2018 Hendi. All rights reserved.
//

import UIKit
import Contacts
import RxSwift
import RxCocoa
class ContactDetailsTableViewController: BaseTableViewController<ContactSelectionCellSmall, SelectablePhone> {


    var selectableContactVariable = BehaviorRelay(value: SelectableContact(contact: CNContact(), phoneNumbers: []))
    var selectableContact: SelectableContact!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectableContactVariable.value.contact.givenName

    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.items[indexPath.row].selected) {
            self.items[indexPath.row].selected = false
        } else {
            self.items[indexPath.row].selected = true
        }
        var selectableContact = selectableContactVariable.value
        selectableContact.phoneNumbers = items
        selectableContactVariable.accept(selectableContact)
        //    selectableContact.phoneNumbers = items
        //      delegate?.onNumberSelected(contact: contact, phoneNumbers: items)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactSelectionCellSmall
        let item: SelectablePhone = items[indexPath.row]


        cell.item = item
        return cell
    }




}
