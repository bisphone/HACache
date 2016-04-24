//
//  HALinkList.h
//  HACache
//
//  Created by Hossein Asgari on 4/21/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HALinkListNode;

@interface HALinkList : NSObject

@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) long long size;
@property (nonatomic, strong) HALinkListNode *head;
@property (nonatomic, strong) HALinkListNode *tail;

- (HALinkListNode *) addObjectToFront:(NSData *)obj forKey:(NSString *)key;
- (HALinkListNode *) addObjectToEnd:(NSData *)obj forKey:(NSString *)key;
- (HALinkListNode *) removeNode:(HALinkListNode *)node;
- (void) moveNodeToHead:(HALinkListNode *)node;
- (NSArray *) allObjects;
- (void)dumpList;


@end


@interface HALinkListNode : NSObject


@property (nonatomic, strong) NSData *obj;
@property (nonatomic , strong) NSString *key;
@property (nonatomic, strong) HALinkListNode *prev;
@property (nonatomic, strong) HALinkListNode *next;

- (instancetype) initWithObject:(id)obj key:(NSString *)key;
- (instancetype) initWithObject:(id)obj prev:(HALinkListNode *)prev next:(HALinkListNode *)next key:(NSString *)key;

@end
