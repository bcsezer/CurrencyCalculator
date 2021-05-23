//
//  SearchPlaceHolderView.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation
import UIKit

class  SearchPlaceHolderView : UIView{
    private let imageView : UIImageView = {
       let imageView = UIImageView()
       let image = UIImage(named: "imDca")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel : UILabel = {
       let title = UILabel()
        title.text = "Search for companies to calculate potential returns via dolar cost averaging."
        title.font = UIFont(name: "AvenirNext-Medium", size: 14)!
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    private lazy var stackView : UIStackView = {//Lazy yani layz loading.
        let stackView = UIStackView(arrangedSubviews: [imageView,titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88.0)
        
        ])
    }
}
