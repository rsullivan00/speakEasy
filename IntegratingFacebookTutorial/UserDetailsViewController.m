//
//  Copyright (c) 2012 Parse. All rights reserved.

#import "UserDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UserDetailsViewController

@synthesize headerView, headerImageView, headerNameLabel;
@synthesize rowTitleArray, rowDataArray, imageData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Facebook Profile"];
    [[self tableView] setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
    
    // Load table header view from nib
    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
    [self.tableView setTableHeaderView:headerView];
    
    // Create array for table row titles
    rowTitleArray = [NSArray arrayWithObjects:@"Location", @"Gender", @"Date of Birth", @"Relationship", nil]; 
    
    // Set default values for the table row data
    rowDataArray = [NSMutableArray arrayWithObjects:@"N/A", @"N/A", @"N/A", @"N/A", nil];
    
    
    // Create request for user's facebook data
    NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture";
    
    // Send request to facebook
    [[PFFacebookUtils facebook] requestWithGraphPath:requestPath 
                                         andDelegate:self];
}


#pragma mark - Facebook Request Delegate methods

/* Callback delegate method for a successful graph request */
-(void)request:(PF_FBRequest *)request didLoad:(id)result 
{    
    // Parse the data received
    NSDictionary *userData = (NSDictionary *)result;
    NSString *name = [userData objectForKey:@"name"];
    NSString *location = [[userData objectForKey:@"location"] objectForKey:@"name"];
    NSString *gender = [userData objectForKey:@"gender"];
    NSString *birthday = [userData objectForKey:@"birthday"];
    NSString *relationship = [userData objectForKey:@"relationship_status"];
    
    // Set received values if they are not nil and reload the table
    if (location) [rowDataArray replaceObjectAtIndex:0 withObject:location];
    if (gender) [rowDataArray replaceObjectAtIndex:1 withObject:gender];
    if (birthday) [rowDataArray replaceObjectAtIndex:2 withObject:birthday];
    if (relationship) [rowDataArray replaceObjectAtIndex:3 withObject:relationship];
    [self.tableView reloadData]; 
    
    // Set the name in the header view label
    [headerNameLabel setText:name];
    
    
    // Download the user's facebook profile picture    
    imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    NSString *pictureURL = [userData objectForKey:@"picture"]; // get the url from the received data
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pictureURL] 
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                          timeoutInterval:2];
    // Run network request asynchronously
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!urlConnection)
        NSLog(@"Failed to download picture");
}

/* Callback delegate method for an unsuccessful graph request */
-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error 
{
    // Since the request failed, we can check if it was due to an invalid session    
    if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"]) {
        NSLog(@"The facebook session was invalidated");
        [self logoutButtonTouchHandler:nil];
    } else {
        NSLog(@"Some other error");
    }
}


#pragma mark - NSURLConnection delegate methods

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // As chuncks of the image are received, we build our data file
    [imageData appendData:data]; 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // All data has been downloaded, now we can set the image in the header image view
    [headerImageView setImage:[UIImage imageWithData:imageData]];
    // Add a nice corner radius to the image
    [headerImageView.layer setCornerRadius:8.0f]; 
    [headerImageView.layer setMasksToBounds:YES];
}


#pragma mark - Logout method

- (void)logoutButtonTouchHandler:(id)sender 
{
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return rowTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        [titleLabel setTag:1]; // We use the tag to set it later
        [titleLabel setTextAlignment:UITextAlignmentRight];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 165, 44)];
        [dataLabel setTag:2]; // We use the tag to set it later
        [dataLabel setFont:[UIFont systemFontOfSize:15]];
        [dataLabel setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:dataLabel];
    }
    
    // Cannot select these cells
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Access labels in the cell using the tag # 
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
    
    // Display the data in the table
    [titleLabel setText:[rowTitleArray objectAtIndex:indexPath.row]];
    [dataLabel setText:[rowDataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
