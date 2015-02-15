//
//  MyApplicationDelegate.m
//  OpenGLEditor
//
//  Created by Rhody Lugo on 2/13/15.
//  For license see LICENSE.TXT
//

#import "MyAppDelegate.h"

#define OPEN_UNTITLED	1

@implementation MyAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{

#if OPEN_UNTITLED

	// Schedule "Checking whether document exists." into next UI Loop.
	// Because document is not restored yet.
	// So we don't know what do we have to create new one.
	// Opened document can be identified here. (double click document file)
	NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(openNewDocumentIfNeeded) object:nil];
	[[NSOperationQueue mainQueue] addOperation: op];

#endif

}

#if OPEN_UNTITLED

-(void)openNewDocumentIfNeeded
{
	NSUInteger documentCount = [[[NSDocumentController sharedDocumentController] documents]count];

	// Open an untitled document what if there is no document. (restored, opened).
	if(documentCount == 0){
		[[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error: nil];
	}
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return YES;
}

#endif

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
