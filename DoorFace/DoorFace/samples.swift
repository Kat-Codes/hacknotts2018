 //add some sample entries
 let entr1 = HistoryEntry()
 let entr2 = HistoryEntry()
 let entr3 = HistoryEntry()
 entr1.photo = UIImage(named: "sample1")
 entr1.date -= 300
 entr2.photo = UIImage(named: "sample2")
 entr2.messageBody = "ALERT: Unrecognised face!"
 entr2.date -= 100
 entr3.photo = UIImage(named: "sample3")
 entr3.messageBody = "Welcome home ;););)"
 entriesArray.append(entr1)
 entriesArray.append(entr2)
 let entr4 = HistoryEntry()
 let entr5 = HistoryEntry()
 
 entr4.photo = UIImage(named: "sample4")
 entr4.messageBody = "Your sister Patrishia has just entered."
 entr5.photo = UIImage(named: "sample5")
 entr5.messageBody = "Better hide! Your ex is here"
 
 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
    // Put your code which should be executed with a delay here
    self.addNewEntry(entry: entr3)
    self.tableView.reloadData()
    self.scrollToBottom(animated: true)
 })
 
 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(21), execute: {
    // Put your code which should be executed with a delay here
    self.addNewEntry(entry: entr4)
    self.tableView.reloadData()
    self.scrollToBottom(animated: true)
 })
 
 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(35), execute: {
    // Put your code which should be executed with a delay here
    self.addNewEntry(entry: entr5)
    self.tableView.reloadData()
    self.scrollToBottom(animated: true)
 })
 
 let image1Url = "https://www.hep.shef.ac.uk/research/atlas/irradiation/images/uos_onwhite_Highqual.jpg"
 loadEntry(imageUrl: image1Url, name: "test")
 //////////////////////////
