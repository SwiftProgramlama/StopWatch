//
//  ViewController.swift
//  StopWatch
//
//  Created by Hüseyin Bagana on 13.05.2016.
//  Copyright © 2016 huseyinbagana. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var isRunnig : Bool = false
    var mainStartTime, splitStartTime, currentTime : TimeInterval?
    var mainElapsedTime : Double = 0.0
    var splitElapsedTime : Double = 0.0
    var mainTotalTime : Double = 0.0
    var splitTotalTime : Double = 0.0
    var times : [String] = []
    var timer:Timer?
    
    @IBOutlet weak var splitTimeLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var tourButton: UIButton!
    @IBOutlet weak var timesTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Tableview datasource atamasını yapıyoruz
        timesTableView.dataSource = self
        setDefaultAll()
    }


    
    func setDefaultAll()
    {
        //Başlangıç değerlerini ve buton isimlerini default hale getiriyoruz
        isRunnig = false
        tourButton.isEnabled = false
        tourButton.setTitle("Tur", for: UIControlState())
   
        //Labellarımızı başlangıç ayarına getiriyoruz
        splitTimeLabel.text = "00:00,00"
        mainTimeLabel.text = "00:00,00"
        
        //Tablo sıfırlama işlemleri
        times.removeAll()
        timesTableView.reloadData()
        
        //Zaman parametrelerinin sıfırlanması
        mainStartTime = nil
        splitStartTime = nil
        currentTime = nil
        splitElapsedTime = 0.0
        mainElapsedTime = 0.0
        mainTotalTime = 0.0
        splitTotalTime = 0.0
        timer?.invalidate()
        timer = nil
    }
    
    func updateLabels()
    {
        currentTime = Date.timeIntervalSinceReferenceDate
        
        //mainTime hesaplaması
        mainTotalTime = currentTime! - mainStartTime! + mainElapsedTime
        
        //splitTime hesaplaması
        splitTotalTime = currentTime! - splitStartTime! + splitElapsedTime
        
        //Labelların update'i
        mainTimeLabel.text = timeToString(mainTotalTime)
        splitTimeLabel.text = timeToString(splitTotalTime)
        
    }
    
    func timeToString(_ time : Double) -> String
    {
        var timeParam = time
        let minutes = Int(timeParam / 60.0)
        timeParam -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(timeParam)
        timeParam -= TimeInterval(seconds)
        
        let fraction = Int(timeParam * 100)
        
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)),\(String(format: "%02d", fraction))"
       
    }
    
    @IBAction func tourOrReset(_ sender: AnyObject)
    {
        //Eğer Kronometre çalışıyorsa Tablo'ya tur ekle
        if (isRunnig)
        {
            times.insert("\(times.count+1). Tur = \(splitTimeLabel.text!)", at: 0)
            timesTableView.reloadData()
        }
        //Eğer Kronometre duruyorsa Resetle
        else
        {
            setDefaultAll()
        }
        
        //Tur zaman değişkenleri sıfırlandı
        splitStartTime = Date.timeIntervalSinceReferenceDate
        splitTotalTime = 0.0
        splitElapsedTime = 0.0
    }
    @IBAction func startOrStop(_ sender: AnyObject)
    {
        //Eğer Kronometre çalışıyorsa
        if (isRunnig)
        {
            //Timer durdurulur
            timer?.invalidate()
            
            isRunnig = false
            (sender as! UIButton).setTitle("Başlat", for: UIControlState())
            
            //Kronometre durduğundan tur butonunun ismini sıfırla olarak değiştiriyoruz
            tourButton.setTitle("Sıfırla", for: UIControlState())
            
            //Kronometre değerlerini tutuyoruz
            splitElapsedTime = splitTotalTime
            mainElapsedTime = mainTotalTime
        }
        //Eğer Kronometre çalışmıyorsa
        else
        {
            isRunnig = true
            (sender as! UIButton).setTitle("Durdur", for: UIControlState())
            
            //Kronometre başladığında tur butonumuzu aktif yapıyoruz
            tourButton.isEnabled = true
            tourButton.setTitle("Tur", for: UIControlState())
            
            //Kronometre için timer ve zaman parametreleri set edilip başlatılır
            mainStartTime = Date.timeIntervalSinceReferenceDate
            splitStartTime = mainStartTime
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateLabels), userInfo: nil, repeats: true)
            
            //TableView scroll eventinde timer durmasın diye 
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            
        }
    }
}

extension ViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = times[(indexPath as NSIndexPath).row]
        
        return cell
    }
}
6
