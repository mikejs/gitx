//
//  PBGitHistoryWatcher.m
//  GitX
//
//  Created by Dave Grijalva on 1/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <CoreServices/CoreServices.h>
#import "PBGitHistoryWatcher.h"

@interface PBGitHistoryWatcher (internal_callback)
- (void) _handleEventCallback;
@end


void PBGitHistoryWatcherCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]){
    PBGitHistoryWatcher *watcher = clientCallBackInfo;
    // TODO: parse out actual file events.  for now, I only care about the change event.
    [watcher _handleEventCallback];
}

@implementation PBGitHistoryWatcher

@synthesize path, delegate;

- (id) initWithPath:(NSString *)thepath {
    if(self = [super init]){
        path = [thepath retain];

        FSEventStreamContext context = {0, self, NULL, NULL, NULL};
        
        // Create and activate event stream
        eventStream = FSEventStreamCreate(kCFAllocatorDefault, &PBGitHistoryWatcherCallback, &context, CFArrayCreate(NULL, (const void **)&path, 1, NULL), kFSEventStreamEventIdSinceNow, 1.0, kFSEventStreamCreateFlagNone);
        FSEventStreamScheduleWithRunLoop(eventStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        FSEventStreamStart(eventStream);
    }
    return self;
}

- (void) _handleEventCallback {
    if(delegate){
        // TODO: send back actual list of files that were modified.
        [delegate historyWatcher:self filesWereModified:[NSArray array]];
    }
}

- (void) dealloc {
    // cleanup 
    FSEventStreamStop(eventStream);
    FSEventStreamUnscheduleFromRunLoop(eventStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamInvalidate(eventStream);
    FSEventStreamRelease(eventStream);
    
    [path release];
    [super dealloc];
}

@end
