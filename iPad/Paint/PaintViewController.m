//**Current Version**
//  PaintViewController.m
//  Paint
//
//  Created by Egepi on 6/8/10.
//              and
//			   ShadowX 
//  Copyright 2010 Electronic Visualization Laboratory. All rights reserved.
//

#import "PaintViewController.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

//Imports necessary for network communication!
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <netdb.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <unistd.h>
#import <errno.h>


@implementation PaintViewController

//Needed for the creation of the new color buttons.
@synthesize ColorOne;
@synthesize ColorTwo;
@synthesize ColorThree;
@synthesize ColorFour;
@synthesize ColorFive;
@synthesize ColorSix;
@synthesize ColorSeven;
@synthesize ColorEight;
@synthesize ColorNine;
@synthesize ColorTen;
@synthesize ColorEleven;
@synthesize ColorTwelve;
@synthesize ColorThirteen;
@synthesize ColorFourteen;
@synthesize ColorFifteen;
@synthesize ColorSixteen;
@synthesize userWell1;
@synthesize userWell2;
@synthesize userWell3;
@synthesize newMixingWell;



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	fromMixingWell = NO;
	fromUserWell1 = NO;
	fromUserWell2 = NO;
	fromUserWell3 = NO;
	
	arrayOfColors = [[NSMutableArray alloc] init];
	
	//Creates an array of the buttons
	[arrayOfColors addObject:ColorOne];
	[arrayOfColors addObject:ColorTwo];
	[arrayOfColors addObject:ColorThree];
	[arrayOfColors addObject:ColorFour];
	[arrayOfColors addObject:ColorFive];
	[arrayOfColors addObject:ColorSix];
	[arrayOfColors addObject:ColorSeven];
	[arrayOfColors addObject:ColorEight];
	[arrayOfColors addObject:ColorNine];
	[arrayOfColors addObject:ColorTen];
	[arrayOfColors addObject:ColorEleven];
	[arrayOfColors addObject:ColorTwelve];
	[arrayOfColors addObject:ColorThirteen];
	[arrayOfColors addObject:ColorFourteen];
	[arrayOfColors addObject:ColorFifteen];
	[arrayOfColors addObject:ColorSixteen];
	[arrayOfColors addObject:newMixingWell];
	[arrayOfColors addObject:userWell1];
	[arrayOfColors addObject:userWell2];
	[arrayOfColors addObject:userWell3];	
	
	
	//------------------------------------------------------------------------------------------------------------------------------------------------
	//Application is properly loaded...create the socket that will connect to the wall.
	currentTool = 1;

	connected = [self connectToHost];

	
	
	
}//End function viewDidLoad, networking code ends with one more function after this one.


//Networking code <Phil Pilosi>
- (bool)connectToHost{
	
	mySocket = socket(AF_INET,SOCK_STREAM,0); // Create instance of the socket!!!
	
	
	//Check to see if the socket was created.
	if(mySocket == -1)
	{
		NSLog(@"There was an error in creating the socket\n");
		NSLog(@"Socket creation failed...Application shutting down\n");
		exit(-1);		
	}
	else 
	{
		NSLog(@"Socket created succesfully moving on\n");
	}
	
	
	//Current list of possible hosts
	//host = gethostbyname("reda-macmini.evl.uic.edu"); //Local host(used for testing).
	//host = gethostbyname("venom.evl.uic.edu");	  //NEC Wall (Venom)
	//host = gethostbyname("131.193.77.102");		  //Omega desk
	//host = gethostbyname("preeka.evl.uic.edu");	  //Tactile
	
	//New way of setting host.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[self grabAddress:[defaults stringForKey:@"ip_address"]];
	const char *cString = [newAddress cStringUsingEncoding:NSASCIIStringEncoding];
	host = gethostbyname(cString);
	
	
	//Setup the socket for connection.
	memset(&mySocketAddr,0,sizeof(struct sockaddr_in));
	mySocketAddr.sin_family = AF_INET;
	mySocketAddr.sin_port   = htons(13337);
	mySocketAddr.sin_addr   = *((struct in_addr *)host->h_addr);
	bzero(&(mySocketAddr.sin_zero),8);
	
	
	//Attempt to connect to host.
	int resultOfConnection = connect(mySocket,(const struct sockaddr *)&mySocketAddr,sizeof(struct sockaddr_in));
	
	
	//Check result of attempting to connect to our host, on failure kill the app.
	if(resultOfConnection == -1)
	{
		NSLog(@"Connection has failed!!!n");
		close(mySocket);
		return false;
	}
	else 
	{
		NSLog(@"Connected to server.\n");
		return true;
	}
	
}

//This function will take the current values in the mixing well and create a c-string out of it using white space character to separate the
//values RGBA and the current tool selected. Then the string is displayed in the Console log and is then sent across the network to the 
//current device using the iPad.

 - (void)sendData{
	 
	 if(!connected)
	 {
		 if(!([self connectToHost]))
		 {
			 return 0;//Failed, don't send anything.
		 }
		 else 
		 {
			 connected = true;
		 }

	 }
 R = 100 + (mixingWellColorArray[0] * 255);
 G = 100 + (mixingWellColorArray[1] * 255);
 B = 100 + (mixingWellColorArray[2] * 255);
 A = 100 + (mixingWellColorArray[3] * 255);
 selectedTool = currentTool + 100;
 
 //Create substrings of the color/tool data.
 sprintf(dataPiece1,"%d",selectedTool);
 sprintf(dataPiece2,"%d",R);
 sprintf(dataPiece3,"%d",G);
 sprintf(dataPiece4,"%d",B);
 sprintf(dataPiece5,"%d",A);
 
 //Create one large string containing the data.
 strcpy(dataToSend,dataPiece1);
 strcat(dataToSend," ");
 strcat(dataToSend,dataPiece2);
 strcat(dataToSend," ");
 strcat(dataToSend,dataPiece3);
 strcat(dataToSend," ");
 strcat(dataToSend,dataPiece4);
 strcat(dataToSend," ");
 strcat(dataToSend,dataPiece5);
 strcat(dataToSend,"\n");
 
 NSLog(@"Sending - R: %d || G: %d || B: %d || A: %d || Tool: %d",R,G,B,A,selectedTool);
 send(mySocket,dataToSend,strlen(dataToSend),0);
	 mixingWellColorArray = NULL;//CHANGED THIS!!!
 }


- (bool)getConnected
{
	return connected;
}

- (int)getSocket
{
	return mySocket;
}

- (void)setConnectedOff
{
	NSLog(@"setConnectedOff called");
	connected = NO; //Use this to reset the connected variable for app in background.
}

- (void)grabAddress:(NSString *)addressToSet
{
	newAddress = addressToSet;
}
//End Networking code
//------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------------
//Touch Event<Phil Pilosi>

//The following three functions will handle catching the actual event of the touch.
//Then pass it to the correct function that will handle the necessary actions.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		[self dispatchFirstTouchAtPoint:[touch locationInView:self.view] forEvent:nil];
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in touches)
	{
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
	}
}
//Tracking touch movement won't be necessary unless we want to add a visual
//of the paint being dragged.(Possible future idea)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
//End Touch Event code
//------------------------------------------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------------------------------------------
//Handle Touch <Phil Pilosi>

//Handle first touch event
- (void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
	
	if(CGRectContainsPoint([[arrayOfColors objectAtIndex:0] frame], touchPoint))
	{
		[self makeColorOne];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:1] frame], touchPoint))
	{
		[self makeColorTwo];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:2] frame], touchPoint))
	{
		[self makeColorThree];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:3] frame], touchPoint))
	{
		[self makeColorFour];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:4] frame], touchPoint))
	{
		[self makeColorFive];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:5] frame], touchPoint))
	{
		[self makeColorSix];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:6] frame], touchPoint))
	{
		[self makeColorSeven];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:7] frame], touchPoint))
	{
		[self makeColorEight];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:8] frame], touchPoint))
	{
		[self makeColorNine];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:9] frame], touchPoint))
	{
		[self makeColorTen];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:10] frame], touchPoint))
	{
		[self makeColorEleven];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:11] frame], touchPoint))
	{
		[self makeColorTwelve];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:12] frame], touchPoint))
	{
		[self makeColorThirteen];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:13] frame], touchPoint))
	{
		[self makeColorFourteen];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:14] frame], touchPoint))
	{
		[self makeColorFifteen];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:15] frame], touchPoint))
	{
		[self makeColorSixteen];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:16] frame], touchPoint))
	{
		fromMixingWell = YES;
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:17] frame], touchPoint))
	{
		//User well 1
		[self makeColorUserWell1];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:18] frame], touchPoint))
	{
		//User well 2
		[self makeColorUserWell2];
	}
	else if(CGRectContainsPoint([[arrayOfColors objectAtIndex:19] frame], touchPoint))
	{
		//User well 3
		[self makeColorUserWell3];
	}
	else 
	{
		//This touch should be ignored...
	}

	
}

//Handle current touch moved event
-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
	
}


//Handle touch end event
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{
	
	if(CGRectContainsPoint([newMixingWell frame], position) && !(fromMixingWell))
	{
		[self newMix];
		fromMixingWell = NO;
	}
	else if((CGRectContainsPoint([userWell1 frame], position)) && (fromMixingWell))
	{
		//NSLog(@"touch up in user well 1");
		[self createUserWell1];
		fromMixingWell = NO;
	}
	else if((CGRectContainsPoint([userWell2 frame], position)) && (fromMixingWell))
	{
		//NSLog(@"touch up in user well 2");
		[self createUserWell2];
		fromMixingWell = NO;
	}
	else if((CGRectContainsPoint([userWell3 frame], position)) && (fromMixingWell))
	{
		//NSLog(@"touch up in user well 3");
		[self createUserWell3];
		fromMixingWell = NO;
	}
	else if(!(CGRectContainsPoint([newMixingWell frame], position)) && fromMixingWell)
	{
		[self newClear];
		fromMixingWell = NO;
	}
	else 
	{
		fromMixingWell = NO;
	}
	
}
//End Handle Touch
//------------------------------------------------------------------------------------------------------------------------------------------------


//Begin Button functions
- (void) makeColorOne;
{
	lastSelectedColor[0] = 0.4140625;
	lastSelectedColor[1] = 0.12890625;
	lastSelectedColor[2] = 0.1328125;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorTwo
{
	lastSelectedColor[0] = 0.62890625;
	lastSelectedColor[1] = 0.2890625;
	lastSelectedColor[2] = 0.0546875;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorThree
{
	lastSelectedColor[0] = 0.31640625;
	lastSelectedColor[1] = 0.2265625;
	lastSelectedColor[2] = 0.1484375;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorFour
{
	lastSelectedColor[0] = 0.9921875;
	lastSelectedColor[1] = 0.3515625;
	lastSelectedColor[2] = 0;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorFive
{
	lastSelectedColor[0] = 0.7890625;
	lastSelectedColor[1] = 0.0546875;
	lastSelectedColor[2] = 0;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorSix
{
	lastSelectedColor[0] = 0.93359375;
	lastSelectedColor[1] = 0.28515625;
	lastSelectedColor[2] = 0.21484375;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorSeven
{
	lastSelectedColor[0] = 0.953125;
	lastSelectedColor[1] = 0.85546875;
	lastSelectedColor[2] = 0;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorEight
{
	lastSelectedColor[0] = 0.1640625;
	lastSelectedColor[1] = 0.3203125;
	lastSelectedColor[2] = 0.7421875;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorNine
{
	lastSelectedColor[0] = 0;
	lastSelectedColor[1] = 0.4765625;
	lastSelectedColor[2] = 0.12890625;
	lastSelectedColor[3] = 1;
	colorSelected = true;}
- (void)makeColorTen
{
	lastSelectedColor[0] = 0;
	lastSelectedColor[1] = 0;
	lastSelectedColor[2] = 0;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorEleven
{
	lastSelectedColor[0] = 0.44921875;
	lastSelectedColor[1] = 0.48046875;
	lastSelectedColor[2] = 0.49609375;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorTwelve
{
	lastSelectedColor[0] = 0.69921875;
	lastSelectedColor[1] = 0.2734375;
	lastSelectedColor[2] = 0.01171875;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorThirteen
{
	lastSelectedColor[0] = 1;
	lastSelectedColor[1] = 1;
	lastSelectedColor[2] = 1;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorFourteen
{
	lastSelectedColor[0] = 0.08203125;
	lastSelectedColor[1] = 0.09375;
	lastSelectedColor[2] = 0.3359375;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorFifteen
{
	lastSelectedColor[0] = 0.0625;
	lastSelectedColor[1] = 0.30078125;
	lastSelectedColor[2] = 0.3046875;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}
- (void)makeColorSixteen
{
	lastSelectedColor[0] = 0.796875;
	lastSelectedColor[1] = 0.46484375;
	lastSelectedColor[2] = 0.1328125;
	lastSelectedColor[3] = 1;
	colorSelected = true;
}

- (void)makeColorUserWell1
{
	//NSLog(@"Testing recall of a user created well");
	userWellColorArray = CGColorGetComponents((userWell1.backgroundColor).CGColor);
	if(userWellColorArray != NULL)
	{
		lastSelectedColor[0] = userWellColorArray[0];
		lastSelectedColor[1] = userWellColorArray[1];
		lastSelectedColor[2] = userWellColorArray[2];
		lastSelectedColor[3] = userWellColorArray[3];
		//lastSelectedColor[3] = 1;
		colorSelected = true;
		fromUserWell1 = YES;
		
	}
}
- (void)makeColorUserWell2
{
	//NSLog(@"Testing recall of a user created well");
	userWellColorArray = CGColorGetComponents((userWell2.backgroundColor).CGColor);
	if(userWellColorArray != NULL)
	{
		lastSelectedColor[0] = userWellColorArray[0];
		lastSelectedColor[1] = userWellColorArray[1];
		lastSelectedColor[2] = userWellColorArray[2];
		lastSelectedColor[3] = userWellColorArray[3];
		colorSelected = true;
		fromUserWell2 = YES;
		
	}
}

- (void)makeColorUserWell3
{
	//NSLog(@"Testing recall of a user created well");
	userWellColorArray = CGColorGetComponents((userWell3.backgroundColor).CGColor);
	if(userWellColorArray != NULL)
	{
		lastSelectedColor[0] = userWellColorArray[0];
		lastSelectedColor[1] = userWellColorArray[1];
		lastSelectedColor[2] = userWellColorArray[2];
		lastSelectedColor[3] = userWellColorArray[3];
		
		colorSelected = true;
		fromUserWell3 = YES;
		
	}
}

- (void)createUserWell1
{
	//NSLog(@"makeUserWell has fired!!!");
	CGFloat newColor0;
	CGFloat newColor1;
	CGFloat newColor2;
	CGFloat newColor3;
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	if(mixingWellColorArray != NULL)
	{
		newColor0 = mixingWellColorArray[0];
		newColor1 = mixingWellColorArray[1];
		newColor2 = mixingWellColorArray[2];
		newColor3 = mixingWellColorArray[3];
		userWell1.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
		well1mixed = itemsMixed; //<dflag>
		NSLog(@"Making User well 1 - Items mixed: %d || userWell1Mixed: %d", itemsMixed, well1mixed);
		NSLog(@"User well 1 - R: %f || G: %f || B: %f || A: %f",newColor0,newColor1,newColor2,newColor3);
	}
	
	
}

- (void)createUserWell2
{
	//NSLog(@"makeUserWell has fired!!!");
	CGFloat newColor0;
	CGFloat newColor1;
	CGFloat newColor2;
	CGFloat newColor3;
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	if(mixingWellColorArray != NULL)
	{
		newColor0 = mixingWellColorArray[0];
		newColor1 = mixingWellColorArray[1];
		newColor2 = mixingWellColorArray[2];
		newColor3 = mixingWellColorArray[3];
		userWell2.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
		well2mixed = itemsMixed; //<dflag>
	}
	
	
}

-(void)createUserWell3
{
	//NSLog(@"makeUserWell has fired!!!");
	CGFloat newColor0;
	CGFloat newColor1;
	CGFloat newColor2;
	CGFloat newColor3;
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	if(mixingWellColorArray != NULL)
	{
		newColor0 = mixingWellColorArray[0];
		newColor1 = mixingWellColorArray[1];
		newColor2 = mixingWellColorArray[2];
		newColor3 = mixingWellColorArray[3];
		userWell3.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
		well3mixed = itemsMixed;//<dflag>
	}
	
	
}

-(void)clearUserWells
{
	CGFloat newColor0 = 0;
	CGFloat newColor1 = 0;
	CGFloat newColor2 = 0;
	CGFloat newColor3 = 0;
	userWell1.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
	userWell2.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
	userWell3.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
}

//End "Button" methods (remade for the UIImageViews)


- (IBAction)Brush:(id)sender 
{	
	if (currentTool == 1)
	{
		[brushButton setBackgroundImage:[UIImage imageNamed:@"pencil2_wshad.png"] forState:UIControlStateNormal];
		currentTool = 2;
	}
	else if (currentTool == 2)
	{
		[brushButton setBackgroundImage:[UIImage imageNamed:@"flatbrush2_wshad.png"] forState:UIControlStateNormal];
		currentTool = 1;
	}
	
	//Send Color and Brush to the server
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	if(!(mixingWellColorArray == NULL))
 	 {
		 [self sendData];
	 }
}


- (void)newMix
{
	CGFloat newColor0;
	CGFloat newColor1;
	CGFloat newColor2;
	CGFloat newColor3;
	CGFloat mix0;
	CGFloat mix1;
	CGFloat mix2;
	CGFloat mix3;
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	if (colorSelected) 
	{
		if (!(mixingWellColorArray == NULL) && (itemsMixed > 0))
		{
			mix0 = mixingWellColorArray[0] * (itemsMixed);
			mix1 = mixingWellColorArray[1] * (itemsMixed);
			mix2 = mixingWellColorArray[2] * (itemsMixed);
			mix3 = mixingWellColorArray[3] * (itemsMixed);
			
			
			if(!(fromUserWell1 || fromUserWell2 || fromUserWell3))
			{
				newColor0 = (mix0 + lastSelectedColor[0])/(itemsMixed+1);
				newColor1 = (mix1 + lastSelectedColor[1])/(itemsMixed+1);
				newColor2 = (mix2 + lastSelectedColor[2])/(itemsMixed+1);
				newColor3 = (mix3 + lastSelectedColor[3])/(itemsMixed+1);
				//newColor3 = 1;
			}
			else 
			{
				if(fromUserWell1 && (itemsMixed > 0))
				{
					newColor0 = (mix0 + lastSelectedColor[0])/(itemsMixed+well1mixed);
					newColor1 = (mix1 + lastSelectedColor[1])/(itemsMixed+well1mixed);
					newColor2 = (mix2 + lastSelectedColor[2])/(itemsMixed+well1mixed);
					//newColor3 = (mix3 + lastSelectedColor[3])/(itemsMixed+1);
					newColor3 = 1;
					NSLog(@"!!Before!!Items mixed: %d || userWell1Mixed: %d", itemsMixed, well1mixed);
					itemsMixed = itemsMixed + well1mixed;
					NSLog(@"!!AFter!!Items mixed: %d || userWell1Mixed: %d", itemsMixed, well1mixed);
					fromUserWell1 = NO;
				}
				else if(fromUserWell1 && (itemsMixed <= 0))
				{
					newColor0 = (mix0 + lastSelectedColor[0])/(itemsMixed+1);
					newColor1 = (mix1 + lastSelectedColor[1])/(itemsMixed+1);
					newColor2 = (mix2 + lastSelectedColor[2])/(itemsMixed+1);
					//newColor3 = (mix3 + lastSelectedColor[3])/(itemsMixed+1);
					newColor3 = 1;
					NSLog(@"!!Before!!Items mixed: %d || userWell1Mixed: %d", itemsMixed, well1mixed);
					itemsMixed = itemsMixed + well1mixed;
					NSLog(@"!!AFter!!Items mixed: %d || userWell1Mixed: %d", itemsMixed, well1mixed);
					fromUserWell1 = NO;					
				}
				
				if(fromUserWell2)
				{
					newColor0 = (mix0 + lastSelectedColor[0])/(itemsMixed+well2mixed);
					newColor1 = (mix1 + lastSelectedColor[1])/(itemsMixed+well2mixed);
					newColor2 = (mix2 + lastSelectedColor[2])/(itemsMixed+well2mixed);
					//newColor3 = (mix3 + lastSelectedColor[3])/(itemsMixed+well2mixed+1);
					newColor3 = 1;
					itemsMixed = itemsMixed + well2mixed;
					fromUserWell2 = NO;
				}
				if(fromUserWell3)
				{
					newColor0 = (mix0 + lastSelectedColor[0])/(itemsMixed+well3mixed);
					newColor1 = (mix1 + lastSelectedColor[1])/(itemsMixed+well3mixed);
					newColor2 = (mix2 + lastSelectedColor[2])/(itemsMixed+well3mixed);
					//newColor3 = (mix3 + lastSelectedColor[3])/(itemsMixed+well3mixed+1);
					newColor3 = 1;
					itemsMixed = itemsMixed + well3mixed;
					fromUserWell3 = NO;
				}
			}
			NSLog(@"R: %f || G: %f || B: %f || A: %f",newColor0,newColor1,newColor2,newColor3);
		}
		else 
		{
			newColor0 = lastSelectedColor[0];
			newColor1 = lastSelectedColor[1];
			newColor2 = lastSelectedColor[2];
			newColor3 = lastSelectedColor[3];
		}
		
		//Set the color in the mixing well.
		newMixingWell.backgroundColor = [UIColor colorWithRed:newColor0 green:newColor1 blue:newColor2 alpha:newColor3];
		
		itemsMixed++; //Keep track of number of paints in mixing well.
		
		colorSelected = false; //This forces the user to have to choose another color instead of rapid tapping.
		
		mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
		
		//Send data!!!
		[self sendData];
	}
}
- (void)newClear
{
	newMixingWell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	itemsMixed = 0;
	colorSelected = false;
	mixingWellColorArray = CGColorGetComponents((newMixingWell.backgroundColor).CGColor);
	
	if (!(mixingWellColorArray == NULL)) 
	{
		//SEND!!!!
		[self sendData];
		//mixingWellColorArray = NULL;
	}
}
/*
 END Button Methods
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	NSLog(@"viewDidUnload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"Dealloc called\n");
    [ColorOne release];
	[ColorTwo release];
	[ColorThree  release];
	[ColorFour release];
	[ColorFive release];
	[ColorSix release];
	[ColorSeven release];
	[ColorEight release];
	[ColorNine release];
	[ColorTen release];
	[ColorEleven release];
	[ColorTwelve release];
	[ColorThirteen release];
	[ColorFourteen release];
	[ColorFifteen release];
	[ColorSixteen release];
	[userWell1 release];
	[userWell2 release];
	[userWell3 release];
	[super dealloc];
}


@end
