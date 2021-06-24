//
//  ViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 5/26/21.
//

import UIKit

class PlayerSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var recentSearchTableView: UITableView!
  
  let defaults = UserDefaults.standard
  var statsURL: String = ""
  var questURL: String = ""
  var username: String = ""
  var searchedNames: [String] = []
  var selectedUsername: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadSearchedNames()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    checkUserdefaults()
    clearFields()
    loadSearchedNames()
    recentSearchTableView.reloadData()
  }
  
  // check if a username has been searched for while previously using the app
  func checkUserdefaults() {
    if defaults.string(forKey: "username") != "" {
      guard let usernameSaved = defaults.string(forKey: "username") else { return }
      usernameTextField.text = usernameSaved.capitalized
    }
  }
  
  // get quests
  func getQuests() {
    if let url = URL(string: questURL) {
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
          let jsonDecoder = JSONDecoder()
          do {
            let parsedJSON = try jsonDecoder.decode(Quests.self, from: data)
            player.quests = parsedJSON
          } catch {
            print(error)
          }
        }
      }.resume()
    }
  }
  
  // get stats
  func getStats() {
    let urlAddingSpaces = statsURL.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: urlAddingSpaces) else {
      print("Error: cannot create URL")
      return
    }
    
    // create the url request & use semaphore to wait for data
    var request = URLRequest(url: url)
    let semaphore = DispatchSemaphore(value: 0)
    
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("Error: error calling GET")
        print(error!)
        return
      }
      guard let data = data else {
        print("Error: Did not receive data")
        return
      }
      guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
        print("Error: HTTP request failed")
        return
      }
      do {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
          print("Error: Cannot convert data to JSON object")
          return
        }
        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
          print("Error: Cannot convert JSON object to Pretty JSON data")
          return
        }
        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
          print("Error: Could print JSON in String")
          return
        }
        
        // if profile doesn't exist
        if prettyPrintedJson.contains("NO_PROFILE") {
          player.stats.error = "NO_PROFILE"
        } else {
          do {
            player.stats = try JSONDecoder().decode(Stats.self, from: prettyJsonData)
          } catch {
            // if profile is OSRS account
            player.stats.error = "OSRS"
          }
        }
      } catch {
        print("Error: Trying to convert JSON data to string")
        return
      }
      semaphore.signal()
    }.resume()
    
    _ = semaphore.wait(wallTimeout: .distantFuture)
  }
  
  // UI setup
  func setup() {
    
    // title
    titleLabel.text = "Enter Character Name"
    
    // text field
    usernameTextField.placeholder = "Username"
    usernameTextField.textAlignment = .center
    usernameTextField.layer.borderWidth = 1
    usernameTextField.layer.cornerRadius = 5
    
    // submit button
    submitButton.setTitle("Submit", for: .normal)
    submitButton.layer.cornerRadius = 5
    submitButton.layer.borderWidth = 1
    submitButton.layer.borderColor = UIColor.black.cgColor
    
    // UITableView
    self.recentSearchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentSearch")
    self.recentSearchTableView.dataSource = self
    recentSearchTableView.delegate = self
  }
  
  // clear username field when returning to UIViewController
  func clearFields() {
    usernameTextField.text = ""
  }
  
  // load searched names to use in UITableView
  func loadSearchedNames() {
    guard let savedNames = defaults.object(forKey: "searchedNames") as? [String] else { return }
    searchedNames = savedNames
    
    if searchedNames == [""] {
      searchedNames = []
    }
  }
  
  // save searched names
  func saveSearchedNames() {
    // if the name does not already exist, add it
    if !searchedNames.contains(username.capitalized) {
      searchedNames.append(username.capitalized)
    }
    
    // save name
    defaults.set(searchedNames, forKey: "searchedNames")
  }
  
  // used to save searchedNames to UserDefaults when deleting a row from recently searched usernames
  func saveAfterDeletingRow() {
    print("searched names after deleting row func: \(searchedNames)")
    defaults.set(searchedNames, forKey: "searchedNames")
  }
  
  // sections for UITableView
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchedNames.count
  }
  
  // setup cell for UITableView
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.font = UIFont(name: "RuneScape-UF", size: 25)
    cell.accessoryType = .disclosureIndicator
    
    // configure the cell
    cell.textLabel?.text = searchedNames[indexPath.row].capitalized
    return cell
  }
  
  // selected cell for serched name
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("tapped")
    let selectedName = searchedNames[indexPath.row]
    selectedUsername = selectedName
    submitButton.sendActions(for: .touchUpInside)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // Override to support editing the table view.
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print("searched names: \(searchedNames)")
      self.searchedNames.remove(at: indexPath.row)
      self.recentSearchTableView.beginUpdates()
      self.recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
      self.recentSearchTableView.endUpdates()
      print("searched names after: \(searchedNames)")
      self.saveAfterDeletingRow()
    }
  }
  
  // submit button tapped
  @IBAction func submitButtonTapped(_ sender: Any) {
    guard let unwrappedUsername = usernameTextField.text else { return }
    
    if selectedUsername == "" {
      username = unwrappedUsername
    } else {
      username = selectedUsername.capitalized
    }
    
    let usernameForURL = username.replacingOccurrences(of: " ", with: "%20")
    defaults.setValue(username, forKey: "username")
    statsURL = "https://apps.runescape.com/runemetrics/profile/profile?user=\(usernameForURL)&activities=20"
    questURL = "https://apps.runescape.com/runemetrics/quests?user=\(usernameForURL)"
    getStats()
    getQuests()
    
    // catch for invalid username / OSRS account
    if player.stats.error == "NO_PROFILE" {
      
      let alert = UIAlertController(title: "Invalid Username", message: "You have entered an invalid RS3 username. Please try again.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else if player.stats.error == "OSRS" {
      
      let alert = UIAlertController(title: "OSRS Account", message: "This app was designed to search for RS3 accounts. OSRS accounts may be supported in the future. Please enter an RS3 username and try again.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else {
      
      // if valid account, sort by id (skill) and save searched names
      player.stats.skillvalues.sort {
        $0.id < $1.id
      }
      saveSearchedNames()
      performSegue(withIdentifier: "StatsTableViewSegue", sender: nil)
    }
  }
}
