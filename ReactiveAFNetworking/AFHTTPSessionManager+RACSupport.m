//
//  AFHTTPSessionManager+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/20/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

#import "AFHTTPSessionManager+RACSupport.h"

@implementation AFHTTPSessionManager (RACSupport)

- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"GET"]
			setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"HEAD"]
			setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"POST"]
			setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
	return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
		
		NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
			if (error) {
				[subscriber sendError:error];
			} else {
				[subscriber sendNext:responseObject];
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

- (RACSignal *)rac_PUT:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
			setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
			setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
			setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(NSDictionary *)parameters method:(NSString *)method {
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
		
		NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
			if (error) {
				[subscriber sendError:error];
			} else {
				[subscriber sendNext:responseObject];
				[subscriber sendCompleted];
			}
		}];
		[task resume];
		
		return [RACDisposable disposableWithBlock:^{
			[task cancel];
		}];
	}];
}

@end

#endif
