# OCAWS.m

Self contained lightweight AWS S3 Upload and Download for iOS and WatchOS

e.g. Upload a file to S3...

```objective-c

#import "OCAWSS3.h"

// Create 
OCAWSS3* s3 = [[AWSS3 alloc] init];
s3.access_key = @"AKXXXXXXXXXXXXXXXXXX";
s3.secret_key = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
s3.endpoint = @"s3-ap-southeast-2.amazonaws.com";
s3.bucket = @"mybucket";

NSURL* url = [s3 put_url:@"test.dat"];

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
[request setHTTPMethod:@"PUT"];

NSURLSession* session = [NSURLSession sharedSession];
NSURLSessionUploadTask* task =
[session uploadTaskWithRequest:request
                      fromFile:[NSURL fileURLWithPath:@"my_file.txt"]
             completionHandler:^(NSData *d, NSURLResponse *r, NSError *e)
                               {if (e) NSLog(@"%@", e.description);}];
[task resume];
```
