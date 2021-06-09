//
//  ViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 5/26/21.
//

import UIKit

var urlToGet: String = ""
var username: String = ""
let baseURL: String = "https://apps.runescape.com/runemetrics/profile/profile?user=\(username)&activities=20"
let defaults = UserDefaults.standard
var stats: Stats = Stats(magic: 1,
                         questsstarted: 1,
                         totalskill: 1,
                         questscomplete: 1,
                         questsnotstarted: 1,
                         totalxp: 1,
                         ranged: 1,
                         activities: [.init(date: "",
                                            details: "",
                                            text: "")],
                         skillvalues: [.init(level: 1,
                                             xp: 1,
                                             rank: 1,
                                             id: 1)],
                         name: "",
                         rank: "",
                         melee: 1,
                         combatlevel: 1,
                         loggedIn: "")

class PlayerSearchViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    clearFields()
    checkUserdefaults()

  }
  
  func checkUserdefaults() {
    if defaults.string(forKey: "username") != "" {
      guard let usernameSaved = defaults.string(forKey: "username") else { return }
      usernameTextField.text = usernameSaved
    }
  }

  func getMethod() {
    print("url to get: \(urlToGet)")
    let urlAddingSpaces = urlToGet.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: urlAddingSpaces) else {
      print("Error: cannot create URL")
      return
    }
    
    // Create the url request
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
        print("pretty json: \(prettyJsonData)")
        if prettyPrintedJson.contains("NO_PROFILE") {
          stats.error = "NO_PROFILE"
        } else {
          do {
            stats = try JSONDecoder().decode(Stats.self, from: prettyJsonData)
        print("it worked: \(prettyPrintedJson)")
          } catch {
            stats.error = "OSRS"
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
  
  func setup() {
    // title
    titleLabel.text = "Enter Character Name"
    
    // text field
    usernameTextField.placeholder = "Username"
    usernameTextField.textAlignment = .center
    
    // submit button
    submitButton.setTitle("Submit", for: .normal)
  }
  
  func clearFields() {
    usernameTextField.text = ""
  }
    
  @IBAction func submitButtonTapped(_ sender: Any) {
    username = usernameTextField.text!
    defaults.setValue(username, forKey: "username")
    urlToGet = "https://apps.runescape.com/runemetrics/profile/profile?user=\(username)&activities=20"
    getMethod()
    if stats.error == "NO_PROFILE" {
      
      let alert = UIAlertController(title: "Invalid Username", message: "You have entered an invalid RS3 username. Please try again.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else if stats.error == "OSRS" {
      
      let alert = UIAlertController(title: "OSRS Account", message: "This app was designed to search for RS3 accounts. OSRS accounts may be supported in the future. Please enter an RS3 username and try again.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else {
      
      stats.skillvalues.sort {
        $0.id < $1.id
      }
      performSegue(withIdentifier: "StatsTableViewSegue", sender: nil)
    }
  }
}
