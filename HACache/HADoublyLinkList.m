//
//  HALinkList.m
//  HACache
//
//  Created by Hossein Asgari on 4/21/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import "HADoublyLinkList.h"

@interface HADoublyLinkList ()

@property (nonatomic, readwrite) NSUInteger length;
@property (nonatomic, readwrite) long long size;

@end

@implementation HADoublyLinkList

- (instancetype) init {
    self = [super init];
    if (self) {
        self.length = 0;
        self.size = 0;
        self.head = nil;
        self.tail = nil;
    }
    return self;
}

- (HALinkListNode *) addObjectToFront:(NSData *)obj forKey:(NSString *)key {
    HALinkListNode *node = [[HALinkListNode alloc] initWithObject:obj key:key];
    if (self.length == 0) {
        self.head = node;
        self.tail = node;
    } else {
        node.next = self.head;
        self.head.prev = node;
        self.head = node;
    }
    self.length += 1;
    self.size += obj.length;
    return node;
}

- (HALinkListNode *) addObjectToEnd:(NSData *)obj forKey:(NSString *)key {
    HALinkListNode *node = [[HALinkListNode alloc] initWithObject:obj key:key];
    if (self.length == 0) {
        self.head = node;
        self.tail = node;
    } else {
        self.tail.next = node;
        node.prev = self.tail;
        self.tail = node;
    }
    self.length += 1;
    self.size += obj.length;
    return node;
}

- (HALinkListNode *) removeNode:(HALinkListNode *)node {
    if (self.head == node) {
        self.head = node.next;
    }
    if (self.tail == node) {
        self.tail = node.prev;
    }
    
    if (node.prev != nil) {
        node.prev.next = node.next;
    }
    if (node.next != nil) {
        node.next.prev = node.prev;
    }
    node.prev = nil;
    node.next = nil;
    self.length -= 1;
    self.size -= ((NSData *)node.obj).length;
    return node;
}

- (void) moveNodeToHead:(HALinkListNode *)node {
    HALinkListNode *removedNode = [self removeNode:node];
    removedNode.next = self.head;
    self.head.prev = removedNode;
    self.head = removedNode;
    self.length += 1;
    self.size += node.obj.length;
    if (self.length == 1) {
        self.tail = self.head;
    }
}

- (NSArray *) allObjects {
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:self.length];
    HALinkListNode *node = self.head;
    while (node != nil) {
        [objects addObject:node.obj];
        node = node.next;
    }
    return objects;
}

-(void)dumpList {
    
    HALinkListNode *node = nil;
    for (node = _head; node; node=node.next) {
        NSLog(@"%@", node.key);
    }
}

- (NSString *)description {
    
    NSString *description = [NSString stringWithFormat:@"head %@ and tail %@ \n", self.head, self.tail];
    
    HALinkListNode *node = self.head;
    while (node != nil) {
        description = [description stringByAppendingString:[node description]];
        node = node.next;
    }
    return description;
}

@end


@implementation HALinkListNode

- (instancetype) initWithObject:(id)obj key:(NSString *)key {
    self = [self initWithObject:obj prev:nil next:nil key:key];
    return self;
}

- (instancetype) initWithObject:(id)obj prev:(HALinkListNode *)prev next:(HALinkListNode *)next key:(NSString *)key {
    self = [super init];
    if (self) {
        self.obj = obj;
        self.prev = prev;
        self.next = next;
        self.key = key;
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"key is %@ and object %@ \n",self.key, self.obj];
}

-(void)dealloc {
    
    NSLog(@"node %@ was deallocated!" , self.key);
}

@end

