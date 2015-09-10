//
//  OCAWSS3.m
//
//  Created by Sam O'Connor on 10/09/2015.
//  Copyright © 2015 Sam O'Connor. All rights reserved.
//


#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "OCAWSS3.h"


@implementation OCAWSS3


static NSString* sha1_hmac_base64(NSString* key, NSString* data)
{
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    const char* k = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char* d = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, k, strlen(k), d, strlen(d), cHMAC);
    
    return  [[[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)]
             base64EncodedStringWithOptions:0];
}


- (NSURL*)url:(NSString*)path
              verb:(NSString*)verb
              type:(NSString*)type
              expiry:(time_t)expiry
{
    // Calculate signature expiry time...
    time_t now = (time_t) [[NSDate date] timeIntervalSince1970];
    expiry += now;
    
    // Build string to sign...
    NSString* digest = [NSString stringWithFormat:
                        @"%@\n"
                        "\n"
                        "%@\n"
                        "%ld\n"
                        "x-amz-security-token:%@\n"
                        "/%@/%@",
                        verb, type, expiry, _token, _bucket, path];
    
    // Sign digest...
    NSString* signature = sha1_hmac_base64(_secret_key, digest);
    
    // URL encode signature...
    signature = [signature stringByAddingPercentEncodingWithAllowedCharacters:
                 [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n"]
                  invertedSet]];
    
    // Build URL...
    return [NSURL URLWithString:
           [NSString stringWithFormat:@"http://%@.%@/%@"
                                       "?AWSAccessKeyId=%@"
                                       "&x-amz-security-token=%@"
                                       "&Expires=%ld"
                                       "&Signature=%@",
            _bucket, _endpoint, path, _access_key, _token, expiry, signature]];
}


- (NSURL*)put_url:(NSString*)path
{
    return [self url:path
                  verb:@"PUT"
                  type:@"application/octet-stream"
                expiry:(60 * 60)];
}


- (NSURL*)get_url:(NSString*)path
{
    return [self url:path
                  verb:@"GET"
                  type:@""
                expiry:(60 * 60)];
}


-(id)init
{
    if (self = [super init])  {
        self.endpoint = @"s3.amazonaws.com";
        self.token = @"";
    }
    return self;
}


@end
