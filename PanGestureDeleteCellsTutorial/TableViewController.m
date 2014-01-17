//
//  TableViewController.m
//  PanGestureDeleteCellsTutorial
//
//  Created by Nick on 1/16/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation TableViewController

-(NSArray *)data
{
    if (!_data) {
        _data = [NSMutableArray arrayWithArray:@[@"cell 1", @"cell 2", @"cell 3", @"cell 4", @"cell 5", @"cell 6", @"cell 7"]];
    }
    return _data;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    
    [self.view addGestureRecognizer:panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    //check if the pan gesture just ended
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        //check how far was the cell moved
        CGPoint translation = [panGesture translationInView:self.view];
        
        //if the cell was moved more than half the width of a cell then delete it
        if (translation.x > 160.0) {
            //get the indexPath of the cell that needs to be deleted
            CGPoint location = [panGesture locationInView:self.tableView];
            NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
            
            //if a cell exists at this position then delete it
            if ([self.tableView cellForRowAtIndexPath:swipedIndexPath]) {
                [self.data removeObjectAtIndex:swipedIndexPath.row];

                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
                
                [UIView animateWithDuration:0.3
                                 animations:^{cell.frame = CGRectMake(cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);}
                                 completion:^(BOOL finished){[self.tableView deleteRowsAtIndexPaths:@[swipedIndexPath]
                                                                                   withRowAnimation:UITableViewRowAnimationAutomatic];
                                 }];
                
            }
        }
        //cell was not moved more than 160 points then snap back to position
        else {
            CGPoint location = [panGesture locationInView:self.tableView];
            NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
            cell.backgroundColor = [UIColor whiteColor];
            [UIView animateWithDuration:0.3
                             animations:^{cell.frame = CGRectMake(0.0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);}
                             completion:^(BOOL finished){}];
        }
        
    }
    // if the user is still dragging the cell
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self.view];
        CGPoint location = [panGesture locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
        //if the draggin was to the right then change the background color to red and move the cell
        if (cell && translation.x > 0) {
            cell.backgroundColor = [UIColor redColor];
            [UIView animateWithDuration:0.1
                             animations:^{cell.frame = CGRectMake(translation.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);}
                             completion:^(BOOL finished){}];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view.superview];
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        }
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

@end
