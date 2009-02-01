//
//  AppController.m
//  Stickler
//
//  Created by Jan Krutisch on 01.02.09.
//  Copyright 2009 mindmatters GmbH & Co. KG. All rights reserved.
//

#import "AppController.h"
#import "AMSerialPortList.h"
#import "AMSerialPortAdditions.h"


@implementation AppController

- (void)awakeFromNib
{	
	// register for port add/remove notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddPorts:) name:AMSerialPortListDidAddPortsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemovePorts:) name:AMSerialPortListDidRemovePortsNotification object:nil];
	[AMSerialPortList sharedPortList]; // initialize port list to arm notifications
	// initializing the fields
	[operatorName setStringValue:@"--"];
	[signalStrength setIntValue:0];
	[self initPort];
	if ([port open]) {
		[port writeString:@"AT+CPIN?\r\n" usingEncoding:NSUTF8StringEncoding error:NULL];
	}
}


- (AMSerialPort *)port
{
    return port;
}

- (void)setPort:(AMSerialPort *)newPort
{
    id old = nil;
	
    if (newPort != port) {
        old = port;
        port = [newPort retain];
        [old release];
    }
}


- (void)initPort {
	NSString *deviceName = @"/dev/cu.HUAWEIMobile-Pcui";
	if (![deviceName isEqualToString:[port bsdPath]]) {
		[port close];
		
		[self setPort:[[[AMSerialPort alloc] init:deviceName withName:deviceName type:(NSString*)CFSTR(kIOSerialBSDModemType)] autorelease]];
		
		// register as self as delegate for port
		[port setDelegate:self];
		if ([port open]) {
			[port readDataInBackground];
		} else { // an error occured while creating port
			[self setPort:nil];
		}
	}
}
	
	- (void)serialPortReadData:(NSDictionary *)dataDictionary {
		// this method is called if data arrives 
		// @"data" is the actual data, @"serialPort" is the sending port
		AMSerialPort *sendPort = [dataDictionary objectForKey:@"serialPort"];
		NSData *data = [dataDictionary objectForKey:@"data"];
		NSLog(@"received %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
		if ([data length] > 0) {
			// continue listening
			[sendPort readDataInBackground];
		} else { // port closed
		}
	}
	
	- (void)didAddPorts:(NSNotification *)theNotification
	{
		// dunno what to do here
		NSLog(@"did add ports: %@", theNotification);
	}
	- (void)didRemovePorts:(NSNotification *)theNotification
	{
		// dunno what to do here
		NSLog(@"did remove ports: %@", theNotification);
	}
@end
