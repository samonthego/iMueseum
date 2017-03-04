//
//  ViewController.swift
//  iMueseum
//
//  Created by Samuel MCDONALD on 2/12/17.
//  Copyright © 2017 Samuel MCDONALD. All rights reserved.
//
import UIKit


class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var allMuseums = [ThisMuseum]()
    var mySearchString:String = ""
    
    
    @IBOutlet var tableView    :UITableView!
    let hostName = "itunes.apple.com/"
    var reachability : Reachability?
    
    @IBOutlet var networkStatusLabel :UILabel!
    
    
  
        /*@IBAction func myArtistPick(_ sender: UITextField) {
        guard let textFieldString = myMuseum.text else {
            return
        }
        
        
        
        let myMuseumString = textFieldString.replacingOccurrences(of: " ", with: "+")
        print("\(myMuseumString)")
        mySearchString = "/search?term=\(myMuseumString)"
        print("mySearchString \(mySearchString)")
    }*/
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Core Methods
    
    func parseJson(data: Data){
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:Any]]
           // print ("JSON:\(jsonResult)")
            
            for resultsDict in jsonResult {
                
                  //  print ("Results:\(resultsDict)")
                let name =    resultsDict["legalname"] as? String ?? "no museum name"
                let address = resultsDict["location_1_address"] as? String ?? "no street address"
                let city =    resultsDict["location_1_city"] as? String ?? "no city"
                let state =   resultsDict["location_1_state"] as? String ?? "no state"
                let zip =     resultsDict["location_1_zip"] as? String ?? "no Zip"
                let stateZip = state + ", " + zip
                
                print("\(name)")
                print("        \(address)")
                print("        \(city)")
                print("        \(stateZip)")

           
                let newThisMuseum = ThisMuseum(museumName: name,locationAddress: address,locationCity: city,locationStateZip: stateZip)
                allMuseums.append(newThisMuseum)      
            }
 
        }catch { print("JSON Parsing Error")}
        print("Here!")
        allMuseums.sort{$0.locationStateZip < $1.locationStateZip}
        DispatchQueue.main.async {
            // need to write a function to sort in the class
            // for equivalence? ==
            //allMuseums.sort()
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    
    func getFile(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
        //let urlString = "https://\(hostName)\(filename)"
        let urlString = "https://data.imls.gov/resource/et8i-mnha.json"
        let url = URL(string: urlString)!
        var request = URLRequest(url:url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let recvData = data else {
                print("No Data")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if recvData.count > 0 && error == nil {
                print("Got Data:\(recvData)")
                let dataString = String.init(data: recvData, encoding: .utf8)
                print("Got Data String:\(dataString)")
                self.parseJson(data: recvData)
            }else{
                print("Got Data of Length 0")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
    }
    
    
    
    
    
    //MARK: - Initialize data Methods
    
     func getFileCheck(){
        guard let reach = reachability else {return}
        if reach.isReachable{
            //getFile(filename: "/classfiles/iOS_URL_Class_Get_File.txt")
            //getFile(filename: "/classfiles/flavors.json")
            getFile()
        }else{
            print("Host Not Reachable. Turn on the Internet")
        }
        
        
    }
    
    //MARK: - tableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("allMuseums count is \(allMuseums.count)")
        
        return allMuseums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThisMuseum

        cell.showMuseum?.text = allMuseums[indexPath.row].museumName
        cell.showAddress?.text = allMuseums[indexPath.row].locationAddress
        cell.showCity?.text = allMuseums[indexPath.row].locationCity
        cell.showStateZip?.text = allMuseums[indexPath.row].locationStateZip
        
        return cell
    }
    
    //MARK: - Reachability Methods
    
    func setupReachability(hostName: String)  {
        reachability = Reachability(hostname: hostName)
        reachability!.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.updateLabel(reachable: true, reachability: reachability)
            }
            
        }
        reachability!.whenUnreachable = {reachability in
            self.updateLabel(reachable: false, reachability: reachability)        }
    }
    
    func startReachability() {
        do{
            try reachability!.startNotifier()
        }catch{
            networkStatusLabel.text = "Unable to Start Notifier"
            networkStatusLabel.textColor = .red
            return
        }
    }
    
    func updateLabel(reachable: Bool, reachability: Reachability){
        if reachable {
            if reachability.isReachableViaWiFi{
                networkStatusLabel.textColor = .green}
            else {
                networkStatusLabel.textColor = .blue
            }
        }else{
            networkStatusLabel.textColor = .red
        }
        networkStatusLabel.text = reachability.currentReachabilityString
    }
    
    //Mark: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupReachability(hostName: hostName)
        startReachability()
        
        tableView.delegate      =   self
        tableView.dataSource    =   self
    
        getFileCheck()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

