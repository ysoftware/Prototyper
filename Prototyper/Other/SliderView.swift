//
//  SliderView.swift
//  https://github.com/ysoftware
//
//  Copyright © 2017 Yaroslav Erohin. All rights reserved.
//

import UIKit

protocol SliderViewDelegate: class {
    /** Constant callback for value change. */
    func sliderView(_ sliderView: SliderView, newValue value: Float)

    /** These get called once every time user starts or ends interaction. */
    func sliderViewWillChangeValue(_ sliderView: SliderView, oldValue:Float)
    func sliderViewDidChangeValue(_ sliderView: SliderView, newValue:Float)
}

extension SliderViewDelegate { /** Making delegate calls optional. */
    func sliderView(_ sliderView: SliderView, newValue value: Float) { }
    func sliderViewWillChangeValue(_ sliderView: SliderView, oldValue:Float) { }
    func sliderViewDidChangeValue(_ sliderView: SliderView, newValue:Float) { }
}

/**
 Conform an object to this protocol and set SliderView's indicator property to receive slider value updates.
 */
protocol SliderViewIndicator {
    var minValue:Float { get set }
    var maxValue:Float { get set }
    var value:Float { get set }
}

class SliderView:UIView {

    // MARK: - Public

    weak var delegate:SliderViewDelegate?
    var indicator:SliderViewIndicator? {
        didSet {
            indicator?.minValue = minValue
            indicator?.maxValue = maxValue
            indicator?.value = value
        }
    }

    /**
     Controls whether slider should react to user's interactions. Default value is `true`. */
    var isEnabled:Bool = true {
        didSet { isUserInteractionEnabled = isEnabled }
    }

    /**
     Controls how far should user swipe before slider starts to change value.
     On lower values, this can be used to set precision of the slider updates.

     Measured in points. Default value is 0.
     */
    var resolution:Float = 0 {
        didSet { if resolution > 0 { resolution = 0 }} // this is correct.
    }

    /**
     Controls sensitivity to user's gestures.

     `1.0` means user has to swipe right through `100%` of view's size to reach maxValue from minValue.
     Default value is 1.2.
     */
    var sensitivity:Float = 1.2 {
        didSet { if sensitivity <= 0 { sensitivity = 0.01 }}
    }

    /** Lowest value of the slider. Cannot be higher than `maxValue`. Default value is 0.0. */
    var minValue:Float = 0.0 {
        didSet {
            if minValue >= maxValue { minValue = maxValue - 0.1 }
            indicator?.minValue = minValue
        }
    }

    /** Highest value of the slider. Cannot be lower than `minValue`. Default value is 1.0. */
    var maxValue:Float = 1.0 {
        didSet {
            if minValue >= maxValue { maxValue = minValue + 0.1 }
            indicator?.maxValue = maxValue
        }
    }

    /** Current value of the slider. Default value is 0.5. */
    var value:Float = 0.5 {
        didSet {
            if value > maxValue { value = maxValue }
            else if value < minValue { value = minValue }
            indicator?.value = value
        }
    }

    /** Middle point between `minValue` and `maxValue`. */
    var middleValue:Float {
        return (minValue + maxValue) / 2
    }

    /** Sets current `value` to middle point between `minValue` and `maxValue`. */
    func setValueToMiddle() {
        value = middleValue
    }

    // MARK: - Private

    private var isChangingValue:Bool = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        recognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(recognizer)
    }

    // MARK: - Touches

    @objc func viewPanned(_ sender: UIPanGestureRecognizer) {
        guard isEnabled else { return }

        switch sender.state {
        case .began:
            if !isChangingValue {
                delegate?.sliderViewWillChangeValue(self, oldValue: value)
                isChangingValue = true
            }
        case .ended, .cancelled, .failed:
            if isChangingValue {
                isChangingValue = false
                delegate?.sliderViewDidChangeValue(self, newValue: value)
            }
        case .changed:
            let translation = Float(sender.translation(in: self).x - sender.translation(in: self).y)
            if abs(translation) >= resolution {
                let dif = maxValue - minValue
                let size = Float(min(frame.size.width, frame.size.height))
                let panSize = size / sensitivity
                let adaptation = panSize / dif

                value += Float(translation / adaptation)
                delegate?.sliderView(self, newValue: value)
                sender.setTranslation(.zero, in: sender.view)
            }
            
        default: break
        }
    }
}
