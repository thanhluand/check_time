//
//  UserTableViewCell.swift
//  GithubUser
//
//  Created by Dang Luan on 2024/08/07.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.layer.borderWidth = 1
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.clipsToBounds = true
    }
    
    class func getNib() -> UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        self.avatar.image = nil
        name.text = ""
        info.text = ""
    }
    
    public func setup(user: User) {
        name.text = user.login
        info.text = user.type
        self.avatar.cacheImage(urlString: user.avatar)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
