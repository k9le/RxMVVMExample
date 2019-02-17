//
//  ViewModel.swift
//  RxMVVMExample
//
//  Created by Vasiliy Fedotov on 10/02/2019.
//  Copyright © 2019 Vasiliy Fedotov. All rights reserved.
//

import Foundation
import RxSwift


class ViewModel {
    
    let disposeBag = DisposeBag()
    
    // incoming
    var searchText = BehaviorSubject<String?>(value: nil)
    var units = BehaviorSubject<DegreeUnit>(value: .celsius)
    
    // outgoing
    var placeString: Observable<String?> {
        return placeTemperatureValues.map { (value) -> String? in
            return value?.0
        }
    }
    
    var temperatureString: Observable<String?> {
        return Observable.combineLatest(placeTemperatureValues, units) { first, second -> String? in
            
            if let first = first {
                if second == .celsius {
                    return String(format:"%.1f °C", first.1)
                } else if second == .fahrenheit {
                    let farenheit = (9.0/5.0)*(first.1) + 32
                    return String(format:"%.1f °F", farenheit)
                }
            }
            
            return nil
        }
    }
    
    private var placeTemperatureValues = PublishSubject<(String, Double)?>()

    init() {
        let searchTextThrottled = searchText.asObserver().throttle(5, scheduler: MainScheduler.instance).distinctUntilChanged()
        
        searchTextThrottled.subscribe(onNext: { [weak self] (value) in
            if let value = value, !value.isEmpty {
                DataManager.shared.getPlace(by: value, completionBlock: { place, success, error in
                    if success, let place = place {
                        DataManager.shared.getTemperature(inLat: place.latitude, lon: place.longitude, completionBlock: { (weather, success, error) in
                            if success, let weather = weather {
                                let val = (place.fullName, weather.value)
                                self?.placeTemperatureValues.onNext(val)
                            } else if let error = error {
                                self?.placeTemperatureValues.onError(error)
                            }
                        })
                    } else if let error = error {
                        self?.placeTemperatureValues.onError(error)
                    }
                })
            } else {
                self?.placeTemperatureValues.onNext(nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
    }
    
}
