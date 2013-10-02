//
//  Country+create.h
//  FlikrFun
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Country.h"

@interface Country (create)

//use default managed document context if context is nil
+ (Country *)countryWithCountryName:(NSString *)countryName
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
