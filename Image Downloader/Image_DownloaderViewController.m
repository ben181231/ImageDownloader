//
//  Image_DownloaderViewController.m
//  Image Downloader
//
//  Created by BenJ Lei on 30/3/14.
//  Copyright (c) 2014 BenJ. All rights reserved.
//

#import "Image_DownloaderViewController.h"

@interface Image_DownloaderViewController ()

@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSNumber *length;

@property (weak, nonatomic) IBOutlet UIButton *startDownloadButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@end

@implementation Image_DownloaderViewController

- (NSMutableData *)imageData{
    if(!_imageData){
        _imageData = [[NSMutableData alloc] init];
    }
    
    return _imageData;
}

- (IBAction)startDownloadImage:(UIButton *)sender {
    [self.downloadProgressView setProgress:0];
    [self.downloadProgressView setHidden:NO];
    [self.imageData setData:nil];
    [self.displayImageView setImage:nil];
    [sender setEnabled:NO];
    
    [NSURLConnection connectionWithRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"]
      ]
                                  delegate:self];
}

/* Get response */
- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response{
    self.length = [NSNumber numberWithLongLong:response.expectedContentLength];
}

/* Receive data */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.imageData appendData:data];
    float progress = self.imageData.length * 1.0 / self.length.floatValue;
    [self.timeLabel setText:[NSString stringWithFormat:@"%0.2f%%", progress * 100]];
    [self.downloadProgressView setProgress:progress animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.timeLabel setText:@"Error..."];
    [self.startDownloadButton setEnabled:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *img = [UIImage imageWithData:self.imageData];
    self.displayImageView.image = img;
    [self.startDownloadButton setEnabled:YES];
    
//    [self saveImage:self.imageData]; // Not yet implement
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.downloadProgressView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
