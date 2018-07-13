//
//  TableViewCell.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CellConfigureType {
    
    case regular(currency: Currency), baseCurrency(currency: Currency)
}

class TableViewCell: UITableViewCell {
    
    private var inActiveColor = UIColor(white: 0.9, alpha: 1)
    
    private var _bag = DisposeBag()
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var value: UITextField!
    
    @IBOutlet weak var underLine: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        underLine.backgroundColor = inActiveColor
        setupTextFieldObserver()
    }
    
    override func prepareForReuse() {
        
        _bag = DisposeBag()
        setupTextFieldObserver()
        
        name.text = ""
        value.text = ""
    }
    
    private func setupTextFieldObserver() {
        
        value.rx.controlEvent([.editingDidBegin])
            .bind { [unowned self] _ in
                
                self.underLine.backgroundColor = UIColor.lightGray
                
            }.disposed(by: _bag)
        
        value.rx.controlEvent([.editingDidEnd])
            .bind { [unowned self] _ in
                
                self.underLine.backgroundColor = self.inActiveColor
                
            }.disposed(by: _bag)
    }
}

extension TableViewCell {
    
    func configure(_ type: CellConfigureType) {
        
        switch type {
            
        case .regular(let currency):
            
            name.text = currency.name
            value.text = formatValue(currency.value * currency.ratio)
            value.isUserInteractionEnabled = false
            
            currency.observableValue
                .flatMap({ Observable.just(self.formatValue($0)) })
                .bind(to: value.rx.text)
                .disposed(by: _bag)
            
        case .baseCurrency(let currency):
            
            self.name.text = currency.name
            value.text = "\(currency.quantity)"
            value.isUserInteractionEnabled = true
            
            value.rx.text.orEmpty
                .bind(onNext: { currency.quantity = Double($0) ?? 0 })
                .disposed(by: _bag)
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        
        return String(format: "%0.2f", value)
    }
}
