//
//  ViewController.swift
//  TableviewCombine
//
//  Created by Ahad Islam on 5/2/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import Combine
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var subscriptions = Set<AnyCancellable>()
        
    private let stories = CurrentValueSubject<[Story], Never>([])
            
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        let api = API()
        api.stories()
            .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in }, receiveValue: { stories in
            self.stories.send(stories)
            self.tableView.reloadData()
        })
        .store(in: &subscriptions)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath)
        cell.textLabel?.text = stories.value[indexPath.row].title
        cell.detailTextLabel?.text = stories.value[indexPath.row].by
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let something = SFSafariViewController(url: URL(string: stories.value[indexPath.row].url)!)
        present(something, animated: true)
    }
    
    
}
