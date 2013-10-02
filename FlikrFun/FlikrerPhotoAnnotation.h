//
//  FlikrerPhotoAnnotation.h
//  FlikrFun
//
//  Created by Shane Fu on 9/28/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlikrerPhotoAnnotation : NSObject <MKAnnotation>

//convinient methods, 
+(FlikrerPhotoAnnotation *)annotationForPhotoes:(NSDictionary *)photoes;

@property (nonatomic, strong) NSDictionary *photoes;

@end
 