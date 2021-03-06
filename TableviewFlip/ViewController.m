//
//  ViewController.m
//  TableviewFlip
//
//  Created by Jimmy Jose on 06/08/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kFlipVerticalTime 0.5
#define kFlipHorizontalTime 0.6
#define kDelayTime 0.0
#define kAnimationEasingType UIViewAnimationOptionCurveEaseInOut

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property IBOutlet UITableView *tableView;
@property NSArray *tableViewDataSource;
@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	_tableViewDataSource = @[@"Hello", @"World"];

	_tableView.delegate = self;
	_tableView.dataSource = self;

	[_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}

	//cell.textLabel.text = [_tableViewDataSource objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
	button.tag = indexPath.row;

	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

	cell.accessoryView = button;

	NSString *imageName = [NSString stringWithFormat:@"%d.jpg", indexPath.row];


	cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
	cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];

	return cell;
}

- (void)buttonPressed:(UIButton *)sender {
	UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];

	NSTimeInterval timeInterval = kFlipHorizontalTime;
	NSString *msg = @"Hello is now changed";
	int tag = 3;
	cell.layer.transform = [self performHorizontalFlipInClockwiseDirection:YES];
	if (sender.tag) {
		tag = 4;
		timeInterval = kFlipVerticalTime;
		msg = @"World is now changed";
		cell.layer.transform = [self performVerticalFlipInClockwiseDirection:YES];
	}


	UIButton *button = (UIButton *)[cell accessoryView];

	[button removeTarget:nil
	              action:NULL
	    forControlEvents:UIControlEventAllEvents];

	[button addTarget:self action:@selector(revert:) forControlEvents:UIControlEventTouchUpInside];

	NSString *imageName = [NSString stringWithFormat:@"%d.jpg", tag];

	[UIView animateWithDuration:timeInterval
	                      delay:kDelayTime
	                    options:kAnimationEasingType
	                 animations: ^{
	    cell.layer.transform = CATransform3DIdentity;
	    cell.textLabel.textColor = [UIColor whiteColor];
	    // cell.textLabel.text = msg;
	    [cell.textLabel sizeToFit];
	    //cell.imageView.image = [UIImage imageNamed:@"0"];
	    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
	    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
	}

	                 completion: ^(BOOL finished) {
	    
	}];
}

- (void)revert:(UIButton *)sender {
	UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];

	NSString *msg = @"Hello";
	NSTimeInterval timeInterval = kFlipHorizontalTime;
	cell.layer.transform = [self performHorizontalFlipInClockwiseDirection:YES];
	if (sender.tag) {
		timeInterval = kFlipVerticalTime;
		msg = @"World";
		cell.layer.transform = [self performVerticalFlipInClockwiseDirection:YES];
        
	}

	NSString *imageName = [NSString stringWithFormat:@"%d.jpg", sender.tag];


	UIButton *button = (UIButton *)[cell accessoryView];

	[button removeTarget:nil
	              action:NULL
	    forControlEvents:UIControlEventAllEvents];

	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

	[UIView animateWithDuration:timeInterval
	                      delay:kDelayTime
	                    options:kAnimationEasingType
	                 animations: ^{
	    cell.layer.transform = CATransform3DIdentity;
	    cell.textLabel.textColor = [UIColor whiteColor];
	    // cell.textLabel.text = msg;
	    [cell.textLabel sizeToFit];
	    //cell.imageView.image = [UIImage imageNamed:@"0"];
	    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
	    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
	}

	                 completion: ^(BOOL finished) {
	    
	}];
}

- (CATransform3D)performVerticalFlipInClockwiseDirection:(BOOL)clockwise {
	return [self getTransformForIndex:1 inClockwiseDirection:clockwise];
}

- (CATransform3D)performHorizontalFlipInClockwiseDirection:(BOOL)clockwise {
	return [self getTransformForIndex:0 inClockwiseDirection:clockwise];
}

- (CATransform3D)getTransformForIndex:(int)index inClockwiseDirection:(BOOL)clockwise {
	
    int direction = clockwise ? -1 : 1;

	float xCord = index ? 1.0 : 0.0;
	float yCord = index ? 0.0 : 1.0;
	float zCord = 0.0;

	//float angle = (180 * direction) * (M_PI / 180);
    float angle = direction * M_PI;

	CGPoint offset = CGPointMake(0, 0);

    CATransform3D transform = CATransform3DIdentity;
    
	transform = CATransform3DRotate(transform, angle, xCord, yCord, zCord);
    
    transform = CATransform3DTranslate(transform, offset.x, offset.y, 0.0);

	
	return transform;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
