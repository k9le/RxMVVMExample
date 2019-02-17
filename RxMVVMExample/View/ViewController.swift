//
//  ViewController.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var scaleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var fullPlaceNameLabel: UILabel!
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)
        scaleSegmentedControl.rx.value.map { DegreeUnit(rawValue: $0)! }.bind(to: viewModel.units).disposed(by: disposeBag)
        
        viewModel.placeString.bind(to: fullPlaceNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.temperatureString.bind(to: valueLabel.rx.text).disposed(by: disposeBag)
        
    }


}

