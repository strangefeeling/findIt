//
//  PostInfoCell.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 20/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // contentView.addSubview(bubbleView)
       // contentView.backgroundColor = .yellow
        
     //   contentView.addSubview(separatorLine)
       
        print(cellWidths)
        
        
        setup()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//      //  let f = contentView.frame
//       // let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 0, 10))
//        //contentView.frame = fr
//       // contentView.layer.cornerRadius = 20
//        //contentView.layer.borderWidth = 1
//    }
    
    let bubbleView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 10
        view.sizeToFit()
        return view
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next-Bold", size:  20)
        label.textColor = .darkGray
        return label
    }()

    
    func setup(){
             contentView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant:  24).isActive = true
        
        //contentView.addSubview(bubbleView)
        contentView.addSubview(message)
        
        message.translatesAutoresizingMaskIntoConstraints = false
        message.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        message.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        message.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
      
      
        
//        if let font = UIFont(name: "Avenir Next", size: 16)
//        {
//            let fontAttributes = [NSFontAttributeName: font]
//            let myText = NSString(string: message.text!)
//            let size = (myText).size(attributes: fontAttributes)
//            print(size)
//        }
        
        
//        
//        bubbleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        bubbleView.widthAnchor.constraint(equalTo: message.widthAnchor, multiplier: 1.1).isActive = true
//        bubbleView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        
        //bubbleView.bottomAnchor.constraint(equalTo: message.bottomAnchor, constant: -2).isActive = true
       /* bubbleView.leftAnchor.constraint(equalTo: message.leftAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: message.topAnchor).isActive = true
        
        if message.text != nil {
            bubbleView.heightAnchor.constraint(equalToConstant: estimatedFrameForText(text: message.text!).height).isActive = true
            bubbleView.widthAnchor.constraint(equalToConstant: estimatedFrameForText(text: message.text!).width).isActive = true}
       /* separatorLine.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 0).isActive = true*/
        separatorLine.widthAnchor.constraint(equalTo: message.widthAnchor).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true*/

    }
    

    
    private func estimatedFrameForText(text: String) -> CGRect{
        //200 nes chatmessagecelle toks, o 1000, nes px ir reik didelio
        let size = CGSize(width: UIScreen.main.bounds.width * 0.7, height: 100000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: UIScreen.main.bounds.height / 33.35)], context: nil)
    }
    
    let separatorLine: UIView = {
       let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var imagee: UIImageView = {
        let image = UIImageView()
        // image.backgroundColor = .red
        image.contentMode = .top
        return image
    }()

    var cellWidths = [CGFloat]()
        
    let message: UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "Avenir Next", size: 16)
        message.numberOfLines = 0
        message.textColor = .black
        message.textAlignment = .left
        message.layer.masksToBounds = true
        message.sizeToFit()
        
        return message
    }()
    
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}
