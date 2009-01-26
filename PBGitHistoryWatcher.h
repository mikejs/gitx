//
//  PBGitHistoryWatcher.h
//  GitX
//
//  Watches a specified path
//
//  Created by Dave Grijalva on 1/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBGitHistoryWatcher;

@protocol PBGitHistoryWatcherDelegate
- (void) historyWatcher:(PBGitHistoryWatcher *)watcher filesWereModified:(NSArray *)paths;
@end


@interface PBGitHistoryWatcher : NSObject {
    NSString *path;
    FSEventStreamRef eventStream;
    __weak id <PBGitHistoryWatcherDelegate> delegate;
}
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, assign) __weak id <PBGitHistoryWatcherDelegate> delegate;

- (id) initWithPath:(NSString *)path;

@end
