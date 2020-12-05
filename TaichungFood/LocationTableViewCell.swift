//
//  LocationTableViewCell.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/1.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    var task: URLSessionDataTask?
    var food: food!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        lbName.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        frame.origin.x = 10
        // Initialization code
    }
    
    /* 解決重複利用 **/
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
