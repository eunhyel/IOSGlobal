//
//  WeatherOfCityHeader.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/20.
//

import UIKit

class WeatherOfCityHeader: UIView {
    
    @IBOutlet weak var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.tag = 555
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.tag = 555
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = .label
        backgroundColor = .systemBackground
    }
    
    func commonInit() {
        let xibName = String(describing: type(of: self))
        if let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView{
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            self.addSubview(view)
        }
    }
}
