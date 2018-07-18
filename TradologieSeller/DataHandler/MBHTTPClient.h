//
//  CFHTTPClient.h
//  CoFETH
//
//  Created by Chandresh Maurya on 14/02/15.
//  Copyright (c) 2015 Chandresh Maurya. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MBHTTPClient : NSObject

@property NSURLRequestCachePolicy cachePolicy;

+(id) sharedInstance;
-(void)cancelAllOperation;

-(void)requestGETServiceOnURL:(NSString *)urlString WithDictionary:(id)requestDictionary withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion;

-(void)requestPOSTServiceOnURL:(NSString *)urlString WithDictionary:(id)requestDictionary withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion;

-(void)requestPOSTMultipartServiceOnURL:(NSString *) urlString withData:(NSData *)photoData withParametes:(id)requestDictionary  withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion;

@end
