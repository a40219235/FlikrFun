//
//  Country+create.m
//  FlikrFun
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Country+create.h"
#import "UIManagedDocument+Manager.h"
@implementation Country (create)

+(Country *)countryWithCountryName:(NSString *)countryName inManagedObjectContext:(NSManagedObjectContext *)context{
	Country *country;
	if (!context) {
		context = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	}
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Country"];
	request.predicate = [NSPredicate predicateWithFormat:@"countryName  = %@", countryName];
	
	//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES];
	//    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	NSError *error = nil;
	NSArray *countries = [context executeFetchRequest:request error:&error];
	
	if (!countries || [countries count] >1) {
		NSAssert(countries, @"countries is nil");
		NSAssert([countries count] > 1, @"matches count = %d", [countries count]);
	}else if (![countries count]){
		country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:context];
		country.countryName = countryName;
	}else{
		country = [countries lastObject];
	}
	
	return country;
}

@end
