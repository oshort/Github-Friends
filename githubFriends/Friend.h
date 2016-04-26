//
//  Friend.h
//  githubFriends
//
//  Created by Oliver Short on 4/25/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *repos;
@property (nonatomic) NSString* attributes;

+(Friend*)createFriendWithDictionary: (NSDictionary*)friendDictionary;

@end
