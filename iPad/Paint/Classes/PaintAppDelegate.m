//
//  PaintAppDelegate.m
//  Paint
//
//  Created by Egepi on 6/8/10.
//				and
//			   ShadowX
//  Copyright Electronic Visualization Laboratory 2010. All rights reserved.
//
#import "PaintViewController.h"
#import "PaintAppDelegate.h"

@implementation PaintAppDelegate

@synthesize window;
@synthesize myViewController;


//Working version tested on simulator, still needs ot be tested on device.
- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	sprintf(message,"%d %d %d %d %d\n",999,999,999,999,999);
    PaintViewController *aViewController = [[PaintViewController alloc]
										 initWithNibName:@"PaintViewController" bundle:[NSBundle mainBundle]];
    [self setMyViewController:aViewController];
    [aViewController release];
	
    UIView *controllersView = [myViewController view];
    [window addSubview:controllersView];
    [window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"app did become active called");
	//[myViewController newClear];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	NSLog(@"app will resign active called");
	if([myViewController getConnected] == YES)
	{
		sameSocket = [myViewController getSocket];
		send(sameSocket,message,strlen(message),0);
		[myViewController newClear];
		[myViewController clearUserWells];
		[myViewController setConnectedOff];
	}
	else if([myViewController getConnected] == NO)
	{
		//Not connected to a device
	}
	else 
	{
		//An error may have occurred, use this to handle logging.
	}
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	NSLog(@"Application will terminate called");
	if([myViewController getConnected] == YES)
	{
		sameSocket = [myViewController getSocket];
		send(sameSocket,message,strlen(message),0);
	}
	else if([myViewController getConnected] == NO)
	{
		//Not connected to a device
	}
	else 
	{
		//An error may have occurred, use this to handle logging.
	}

}

//-(void)application

- (void)dealloc {
	NSLog(@"delegate dealloc");
    [myViewController release];
    [window release];
    [super dealloc];
}

@end