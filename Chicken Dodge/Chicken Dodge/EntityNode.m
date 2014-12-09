//
//  EntityNode.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/17/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "EntityNode.h"

@implementation EntityNode


- (id)initWithPosition:(CGPoint)position {
    
    if (self = [super init]) {
        self.position = position;
    }
    return self;
}

- (void)update:(CFTimeInterval)currentTime{
    
    // Overridden by subclass
    
}
- (void)configurePhysics{
    // Overridden by subclass
}
@end
