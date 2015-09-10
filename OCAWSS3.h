//
//  OCAWSS3.h
//
//  Created by Sam O'Connor on 10/09/2015.
//  Copyright © 2015 Sam O'Connor. All rights reserved.
//


#ifndef OCAWSS3_h
#define OCAWSS3_h

@interface OCAWSS3 : NSObject {}

@property (copy) NSString *access_key;
@property (copy) NSString *secret_key;
@property (copy) NSString *token;
@property (copy) NSString *endpoint;
@property (copy) NSString *bucket;

-(id)init;

- (NSURL*)url:(NSString*)path
           verb:(NSString*)verb
           type:(NSString*)type
        expiry:(time_t)expiry;

- (NSURL*)put_url:(NSString*)path;

@end

#endif /* OCAWSS3_h */
