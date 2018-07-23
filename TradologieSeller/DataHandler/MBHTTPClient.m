
//  MBHTTPClient.m
//  CoFETH
//
//  Created by Anil Khanna on 14/02/15.
//  Copyright (c) 2015 Anil Khanna. All rights reserved.
//

#import "MBHTTPClient.h"
#import "AfNetworking.h"
#import "AFHTTPSessionManager+RetryPolicy.h"
#import "SharedManager.h"

#define SHARED_INSTANCE(...) ({\
static dispatch_once_t pred;\
static id sharedObject;\
dispatch_once(&pred, ^{\
sharedObject = (__VA_ARGS__);\
});\
sharedObject;\
})

#define RETRYCOUNTER 2
#define RETRYINTERVAL 10.0
#define FATALSTATUSCODE @[@401, @403]

@interface MBHTTPClient(){
    AFHTTPSessionManager * globalManager;
}
@end

@implementation MBHTTPClient
+(id) sharedInstance
{
    static dispatch_once_t pred = 0;
    static id sharedObject;
    dispatch_once(&pred, ^{
        sharedObject = [self new];
    });
    
    if (![SharedManager sharedInstance].isNetAvailable) {
        [sharedObject cancelAllOperation];
        return nil;
    }
    
    return sharedObject;
}
-(void)cancelAllOperation{
    [globalManager.operationQueue cancelAllOperations];
}

-(void)requestGETServiceOnURL:(NSString *)urlString WithDictionary:(id)requestDictionary withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion
{
    //[AppDelegate shared].oneAlertViewAlreadyThere = NO;
    NSLog(@"=============================================================================");
    
    NSLog(@"URL : %@",urlString);
    
    if (requestDictionary) {
        NSLog(@"REQUEST : %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:requestDictionary options:0 error:nil] encoding:NSUTF8StringEncoding]);
    }
    
    NSLog(@"=============================================================================");
    
    AFHTTPSessionManager * manager = [self requestOperationManager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"Success = %@",responseObject);
        
        completion(task,nil,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(task, error, nil);
        
    }retryCount:RETRYCOUNTER retryInterval:RETRYINTERVAL progressive:false fatalStatusCodes:FATALSTATUSCODE];

}

-(void)requestPOSTServiceOnURL:(NSString *)urlString WithDictionary:(id)requestDictionary withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion{
    
    NSLog(@"=============================================================================");
    
    NSLog(@"URL : %@",urlString);
    
    if (requestDictionary) {
        NSLog(@"REQUEST : %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:requestDictionary options:0 error:nil] encoding:NSUTF8StringEncoding]);
    }
    
    NSLog(@"=============================================================================");
    AFHTTPSessionManager *manager = [self requestOperationManager];
    
    [manager POST:urlString parameters:requestDictionary progress:nil
          success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        NSDictionary *dict   = [NSDictionary dictionaryWithDictionary:[task.currentRequest allHTTPHeaderFields]];
        NSLog(@"Success = %@ %@ ",responseObject,dict);
        
        completion(task,nil,responseObject);
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        //NSDictionary *dict   = [NSDictionary dictionaryWithDictionary:[task.currentRequest allHTTPHeaderFields]];
        completion(task, error, nil);
        
    } retryCount:RETRYCOUNTER retryInterval:RETRYINTERVAL progressive:false fatalStatusCodes:FATALSTATUSCODE];
    
}

#pragma mark - Request Operation Manager

-(AFHTTPSessionManager *)requestOperationManager
{
    if(globalManager==nil){
        globalManager = [[AFHTTPSessionManager alloc] init];
        [globalManager setRetryPolicyLogMessagesEnabled:YES];
    }

    globalManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [globalManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    ((AFJSONResponseSerializer *)globalManager.responseSerializer).readingOptions=NSJSONReadingAllowFragments;

    //globalManager.requestSerializer  = [self addAuthorizationKey];
    globalManager.requestSerializer.cachePolicy = self.cachePolicy;

    [globalManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    globalManager.requestSerializer.timeoutInterval = 30;
    [globalManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    return  globalManager;
}


-(void)requestPOSTMultipartServiceOnURL:(NSString *) urlString withData:(NSData *)photoData withParametes:(id)requestDictionary  withCompletion:(void (^)(NSURLSessionDataTask *task, NSError *error, id response))completion
{
    /*
     // 1. Create `AFHTTPRequestSerializer` which will create your request.
     AFJSONRequestSerializer *serializer = [self addAuthorizationKey];
     
     // 2. Create an `NSMutableURLRequest`.
     NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
     if (photoData) {
     [formData appendPartWithFileData:photoData
     name:@"image_path"
     fileName:@"profilePic.jpg"
     mimeType:@"image/jpeg"];
     }
     } error:nil];
     */
    
    
    AFHTTPSessionManager *manager = [self requestOperationManager];
    
    [manager POST:urlString parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         if (photoData)
         {
             [formData appendPartWithFileData:photoData
                                         name:@"Image"
                                     fileName:@"Tradology.png"
                                     mimeType:@"image/jpeg"];
         }
     } progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@ ", responseObject);
         completion(task,nil,responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         completion(task, error, nil);
         
         
         NSLog(@"Error: %@", error);
         
     } retryCount:RETRYCOUNTER retryInterval:RETRYINTERVAL progressive:false fatalStatusCodes:FATALSTATUSCODE];
}

- (void)downloadDocumentFileFromURL:(NSString *) URL withProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock
{
    //Configuring the session manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *formattedURL = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:formattedURL];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {
         CGFloat written = totalBytesWritten;
         CGFloat total = totalBytesExpectedToWrite;
         CGFloat percentageCompleted = written/total;
         
         progressBlock(percentageCompleted);
     }];
    
    //Start the download
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
      {
          //Getting the path of the document directory
          NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
          NSURL *fullURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
          
          //If we already have a video file saved, remove it from the phone
          [self removeVideoAtPath:fullURL];
          return fullURL;
          
      } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
      {
          if (!error) {
              //If there's no error, return the completion block
              completionBlock(filePath);
          } else {
              //Otherwise return the error block
              errorBlock(error);
          }
          
      }];
    
    [downloadTask resume];
}


- (void)removeVideoAtPath:(NSURL *)filePath
{
    NSString *stringPath = filePath.path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:stringPath]) {
        [fileManager removeItemAtPath:stringPath error:NULL];
    }
}

@end
