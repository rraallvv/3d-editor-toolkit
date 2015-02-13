//
//  MyApplicationDelegate.m
//  OpenGLEditor
//
//  Created by Rhody Lugo on 2/13/15.
//  For license see LICENSE.TXT
//

#import "MyApplicationDelegate.h"

@implementation MyApplicationDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
	// Schedule "Checking whether document exists." into next UI Loop.
	// Because document is not restored yet.
	// So we don't know what do we have to create new one.
	// Opened document can be identified here. (double click document file)
	NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(openNewDocumentIfNeeded) object:nil];
	[[NSOperationQueue mainQueue] addOperation: op];
}

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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
