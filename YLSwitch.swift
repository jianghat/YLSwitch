//
//  YLSwitch.swift
//  gamefi-ios
//
//  Created by ym on 2024/3/18.
//

import UIKit

typealias YLSwitchChangeBlock = (_ isOn: Bool) -> Void

class YLSwitch: UIControl {
    private var didSetFrame: Bool = false
    
    private var backgroundImage: UIImage?
    private var foregroundImage: UIImage?
    
    var pointImage: UIImage? {
        didSet {
            pointImageView.image = pointImage
        }
    }
    
    var isOn: Bool = false {
        didSet {
            backgroundImageView.image = isOn ? foregroundImage : backgroundImage
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var changeBlock: YLSwitchChangeBlock?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(statusChanged), for: .touchUpInside)
        addSubview(backgroundImageView)
        addSubview(pointImageView)
    }
    
    convenience init(backgroundImage: UIImage, foregroundImage: UIImage) {
        self.init(frame: .zero)
        self.backgroundImage = backgroundImage
        self.foregroundImage = foregroundImage
        self.backgroundImageView.image = backgroundImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (didSetFrame) {
            return
        }
        didSetFrame = true
        
        let pointSize = pointImage?.size ?? .zero
        let pointX = isOn ? frame.size.width - pointSize.width : 0
        let pointY = (frame.size.height - pointSize.height)/2.0
        pointImageView.frame = CGRect(x: pointX, y: pointY, width: pointSize.width, height: pointSize.height)
        
        let backgroundSize = backgroundImage?.size ?? .zero
        let backgroundY = (frame.size.height - backgroundSize.height)/2.0
        backgroundImageView.frame = CGRectMake(0, backgroundY, frame.size.width, backgroundSize.height)
    }
    
    private lazy var pointImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}

extension YLSwitch {
    @objc func statusChanged() {
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let `self` = self else { return }
            let pointX = isOn ? 0 : frame.size.width - pointImageView.width
            pointImageView.left = pointX
            isOn = !isOn
        } completion: {[weak self] flag in
            if (flag) {
                guard let `self` = self else { return }
                changeBlock?(isOn)
            }
        }
    }
}
