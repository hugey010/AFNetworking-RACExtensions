//
//  AFHTTPSessionManager+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/20/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

#import "AFHTTPSessionManager+RACSupport.h"

NSString *const RACAFNResponseObjectErrorKey = @"responseObject";
NSString *const RACAFNResponseErrorKey = @"response";

@implementation AFHTTPSessionManager (RACSupport)

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"GET"]
			setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"HEAD"]
			setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"POST"]
			setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
	return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
		
		NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
			if (error) {
                [subscriber sendError:[AFHTTPSessionManager errorWithError:error
                                                  response:response
                                            responseObject:responseObject]];
			} else {
				[subscriber sendNext:RACTuplePack(responseObject, response)];
				[subscriber sendCompleted];
			}
		}];
		[task resume];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock:", self.class, path, parameters];
;
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
			setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
			setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
			setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
		
		NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
			if (error) {
                [subscriber sendError:[AFHTTPSessionManager errorWithError:error
                                                  response:response
                                            responseObject:responseObject]];
			} else {
				[subscriber sendNext:RACTuplePack(responseObject, response)];
				[subscriber sendCompleted];
			}
		}];
		[task resume];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

+ (NSError*)errorWithError:(NSError*)error response:(NSURLResponse*)response responseObject:(id)responseObject {
    NSMutableDictionary* userInfo = [error.userInfo mutableCopy];
    if (response) {
        userInfo[RACAFNResponseErrorKey] = response;
    }
    if (responseObject) {
        userInfo[RACAFNResponseObjectErrorKey] = responseObject;
    }
    return [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
}

@end

#endif
