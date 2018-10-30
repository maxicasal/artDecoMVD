//
//  BuildingAnnotationView.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 9/7/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import MapKit

class BuildingAnnotationView: MKAnnotationView{

    private var calloutView: BuildingView?
    private var hitOutside:Bool = true

    convenience init(annotation:MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: "pin")

        canShowCallout = false;
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let hitView = super.hitTest(point, with: event)

        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        
        return hitView;
        
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        let rect = self.bounds
        var isInside = rect.contains(point)

        if(!isInside) {
            for view in self.subviews {

                isInside = view.frame.contains(point)
                break;
            }
        }
        
        return isInside
    }

    
}
