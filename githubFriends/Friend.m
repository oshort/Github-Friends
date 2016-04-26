//
//  Friend.m
//  githubFriends
//
//  Created by Oliver Short on 4/25/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+(Friend*)createFriendWithDictionary: (NSDictionary*)friendDictionary{
    Friend *newFriend = nil;
    if(friendDictionary){
            newFriend = [[Friend alloc] init];
            
            newFriend.name = friendDictionary[@"login"];
            newFriend.attributes = friendDictionary;
        }
        return newFriend;
    }


@end
