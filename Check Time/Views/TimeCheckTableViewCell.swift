//
//  TimeCheckTableViewCell.swift
//  Time Check
//
//  Created by Dang Luan on 2024/09/18.
//

import UIKit

class TimeCheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resultLB: UILabel!
    
    let inTimeResult = "含まれる"
    let notInTimeResult = "含まれない"
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func getNib() -> UINib {
        return UINib(nibName: "TimeCheckTableViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        self.icon.image?.withTintColor(.white)
    }
    
    public func setup(data: TimeChecked) {
        let result = "\(data.checkTime)時は\(data.startTime)~\(data.endTime)時の範囲に\(data.result ? inTimeResult : notInTimeResult)"
        self.icon.tintColor = data.result ? .green : .red
        self.resultLB.text = result
//        name.text = user.login
//        info.text = user.type
//        self.avatar.cacheImage(urlString: user.avatar)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
