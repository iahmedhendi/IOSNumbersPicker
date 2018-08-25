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
class SelectContactTableViewController: BaseTableViewController<ContactSelectionCell, SelectableContact>, UISearchResultsUpdating, SelectNumberDelegate {


    func onNumberSelected(contact: CNContact, phoneNumbers: [SelectablePhone]) {
        let index = findIndex(items: items, contact: contact)
        self.items[index!].phoneNumbers = phoneNumbers
        self.tableView.reloadData()
    }

    func findIndex(items: [SelectableContact], contact: CNContact) -> Int? {
        return items.index(where: { (item) -> Bool in
            item.contact == contact
        })!
    }


    var filteredItems = [SelectableContact]()
    let searchController = UISearchController(searchResultsController: nil)
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Contact "
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = searchController
        definesPresentationContext = true
        fetchContacts()

        navigationController?.navigationBar.barTintColor = UIColor(named: "primary")!
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))


    }
    @objc func doneAction() {
        print("Selected numbers is ")
        for item in items {
            if item.phoneNumbers.count > 0 {
                for phone in item.phoneNumbers {
                    if phone.selected {
                        print(phone.number)
                    }
                }
            }
        }
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Access Request Failed ...", err)
            }
            if granted {
                print("Access Granted")

                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        self.items.append(SelectableContact(contact: contact, phoneNumbers: []))

                    })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                } catch let err {
                    print("Failed to enumrate contacts", err)
                }

            } else {
                print("Access Denied")
            }

        }
    }


//    func filteredItems() -> Bool {
//        // Returns true if the text is empty or nil
//        return searchController.searchBar.text?.isEmpty ?? true
//    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }


    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter({ (contact: SelectableContact) -> Bool in
            return contact.contact.givenName.lowercased().contains(searchText.lowercased())
        })

        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        }

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactSelectionCell
        var item: SelectableContact
        if isFiltering() {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }


        cell.checkImageView.onTap {
            if self.isFiltering() {
                if self.hasSelectedNumbers(item: self.filteredItems[indexPath.row]) {
                    self.deselectAllNumbers(item: &self.filteredItems[indexPath.row])
                    let item = self.filteredItems[indexPath.row]
                    if let index = self.findIndex(items: self.items, selectableContact: item) {
                        self.deselectAllNumbers(item: &self.items[index])
                    }
                } else {
                    self.selectAllNumbers(item: &self.filteredItems[indexPath.row])
                    let item = self.filteredItems[indexPath.row]
                    if let index = self.findIndex(items: self.items, selectableContact: item) {
                        self.selectAllNumbers(item: &self.items[index])
                    }
                }

            } else {
                if self.hasSelectedNumbers(item: self.items[indexPath.row]) {
                    self.deselectAllNumbers(item: &self.items[indexPath.row])
                } else {
                    self.selectAllNumbers(item: &self.items[indexPath.row])
                }
            }


            self.tableView.reloadData()
        }

        cell.item = item
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = ContactDetailsTableViewController()

        if self.isFiltering() {
            detailsVC.items = self.filteredItems[indexPath.row].phoneNumbers
            detailsVC.selectableContactVariable.accept(self.filteredItems[indexPath.row])
            //   detailsVC.contact = self.filteredItems[indexPath.row].contact
        } else {
            detailsVC.items = self.items[indexPath.row].phoneNumbers
            //     detailsVC.contact = self.items[indexPath.row].contact
            detailsVC.selectableContactVariable.accept(self.self.items[indexPath.row])

        }
        detailsVC.selectableContactVariable.asObservable() //Observing the value
        .subscribe(onNext: { selectableContact in
            if self.isFiltering() {
                self.filteredItems[indexPath.row] = selectableContact
            } else {
                self.items[indexPath.row] = selectableContact

            }
            self.syncCheckedItems(items: &self.items, fillteredItems: &self.filteredItems)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        self.navigationController!.pushViewController(detailsVC, animated: true)
    }


    func hasSelectedNumbers(item: SelectableContact) -> Bool {
        return item.phoneNumbers.filter({ $0.selected }).count > 0
    }

    func selectAllNumbers(item: inout SelectableContact) {
        for index in 0..<item.phoneNumbers.count {
            item.phoneNumbers[index].selected = true
        }
    }

    func deselectAllNumbers(item: inout SelectableContact) {
        for index in 0..<item.phoneNumbers.count {
            item.phoneNumbers[index].selected = false
        }
    }

    func syncCheckedItems(items: inout [SelectableContact], fillteredItems: inout [SelectableContact]) {
        for (_, item) in fillteredItems.enumerated() {
            let contactIndex = findIndex(items: items, contact: item.contact)
            if let contactIndex = contactIndex {
                items[contactIndex] = item
            }

        }
    }

    func findIndex(items: [SelectableContact], selectableContact: SelectableContact) -> Int? {
        return items.index(where: { (item) -> Bool in
            item.contact == selectableContact.contact
        })!
    }

}
