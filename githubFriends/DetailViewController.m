//
//  DetailViewController.m
//  githubFriends
//
//  Created by Oliver Short on 4/25/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

#import "DetailViewController.h"
#import "RepoTableViewCell.h"


@interface DetailViewController () <NSURLSessionDelegate, UITableViewDataSource>{
    
}

@property NSMutableData *receivedData;
@property NSMutableArray *repoArray;

@property UITableView *tableView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view (again).
        [self configureView];
    }
}


- (void)configureView{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        NSString *userName = [self.detailItem description];
        NSString* urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos", userName];
        NSURL *url = [NSURL URLWithString:urlString];
        // vv Creating a local variable that is pointing at the default value for how to create URL sessions vv. Doing this bc sometimes phones have constraints about what domains a user can go to.
        
        NSURLSessionConfiguration*config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]]; //mainQueue is the main thread that allows all of the UI magic to happen. have to do this on the main thread and when we update the UI things will update correctly.
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url]; //create a datatask from the session. dattasks gets data from a URL
        [dataTask resume];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // [self configureView];
    self.repoArray = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:@"repocell"];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

//Means that we started receiving data -

//creating something that holds the data we're receiving. going to call this method several times. if we have something already, we want to append what we just received
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc]initWithData:data];
    }else{
        [self.receivedData appendData:data];
    }
}

//once we get to "did complete with error" it means we've gotten to the end

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    if (!error) {
 //       NSLog(@"Download Successful! %@", [self.receivedData description]);
        NSError *error;
        NSArray*jsonResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
        self.repoArray =[jsonResponse mutableCopy];
        if(self.repoArray){
            self.receivedData=nil;
            [self.tableView reloadData];
        }
        NSLog(@"%@", [self.repoArray description]);
    }
}


#pragma mark Table View Cell Configuration
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Repo" forIndexPath:indexPath];
    
    cell.textLabel.text = self.repoArray[indexPath.row][@"name"];
    
    return cell;
}

@end
