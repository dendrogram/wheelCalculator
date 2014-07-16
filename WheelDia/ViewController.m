//--------------------------------------------------------------
//
//  ViewController.m
//  WheelDia
//
//  First Created by Jonathan Howell on 21/10/2013.
//  This version 16/7/14
//
//  Copyright (c) 2014 Jonathan Howell. All rights reserved.
//
//--------------------------------------------------------------

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *moduleTxt;
@property (strong, nonatomic) IBOutlet UITextField *wheelTeethTxt;

@property (strong, nonatomic) IBOutlet UILabel *odWheelLbl;
@property (strong, nonatomic) IBOutlet UILabel *odPinionLbl;
@property (strong, nonatomic) IBOutlet UILabel *odWheelThLbl;
@property (strong, nonatomic) IBOutlet UILabel *odPinionThLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *leavesPinionSegCtrl;
@property (strong, nonatomic) IBOutlet UILabel *dpLbl;
@property (strong, nonatomic) IBOutlet UILabel *pdLbl;
@property (strong, nonatomic) IBOutlet UILabel *pdpLbl;

@end

@implementation ViewController

@synthesize
    moduleTxt,
    wheelTeethTxt,
    odPinionLbl,
    odPinionThLbl,
    odWheelLbl,
    odWheelThLbl,
    leavesPinionSegCtrl,
    dpLbl,  //diametrical pitch
    pdLbl,  //pitch diameter wheels
    pdpLbl; //pitch diameter wheels

float module    = 0.5;
int   teethWheel  = 8;
float teethPinion = 6;

float addendaWheels        = 2.76;
float addendaPinions678    = 1.71;
float addendaPinions101216 = 1.61;

float odWheelmm  = 0;
float odPinionmm = 0;
float odWheelth  = 0;
float odPinionth = 0;
float dp  = 0;
float pd  = 0;
float pdp = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //set the delegates or text did start/end will not work
    moduleTxt.delegate = self;
    wheelTeethTxt.delegate = self;
    //change the calcs when the segments alter
    [leavesPinionSegCtrl addTarget:self action:@selector(calculateBtn:)forControlEvents:UIControlEventValueChanged];

    //run calcs with defaults once
    [self calculateBtn:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateBtn:(id)sender {
    //from text boxes
    module      = [moduleTxt.text floatValue];
    teethWheel  = [wheelTeethTxt.text intValue];
    teethPinion = (leavesPinionSegCtrl.selectedSegmentIndex)+6;
    NSLog(@"teeth pinion=%f",teethPinion);

    //constants
    //addendaWheels        = 2.76;
    //addendaPinions678    = 1.71;
    //addendaPinions101216 = 1.61;

    //do the calculation
    //(nt + addendum) * module
    odWheelmm  = (addendaWheels + teethWheel)*module;
    
    if (teethPinion<10) {
        odPinionmm  = (addendaPinions678 + teethPinion) * module;
    }else{
        odPinionmm  = (addendaPinions101216 + teethPinion) * module;
    }

    //convert to thousandths mm x 100 / 2.54
    odWheelth = odWheelmm * 100 / 2.54;
    odPinionth = odPinionmm * 100 / 2.54;

    dp  = 25.4 / module;
    pd  = module * teethWheel;
    pdp = module * teethPinion;

    //newStr = [str substringToIndex:8]; //chars to print

    //put the results in the labels
    //mm's
    odWheelLbl.text = [[NSString stringWithFormat:@"%f00000",odWheelmm]substringToIndex:6];
    odPinionLbl.text = [[NSString stringWithFormat:@"%f00000",odPinionmm]substringToIndex:6];
    //thou's
    odWheelThLbl.text = [[NSString stringWithFormat:@"%f00000",odWheelth]substringToIndex:6];
    odPinionThLbl.text = [[NSString stringWithFormat:@"%f000",odPinionth]substringToIndex:5];
    dpLbl.text = [[NSString stringWithFormat:@"%f000",dp]substringToIndex:5];
    pdLbl.text = [[NSString stringWithFormat:@"%f000",pd]substringToIndex:5];
    pdpLbl.text = [[NSString stringWithFormat:@"%f000",pdp]substringToIndex:5];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //used to clear keyboard if screen touched
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];

    [super touchesBegan:touches withEvent:event];
}

//one block for each input var to colour the boxes and test the validity
//******** Start of block *********


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    // change the color of the text box when you touch it
    if(textField==self->moduleTxt){
        moduleTxt.backgroundColor = [UIColor greenColor];
        // NSLog(@"module");
    }
    if(textField==self->wheelTeethTxt){
        wheelTeethTxt.backgroundColor = [UIColor greenColor];
        // NSLog(@"teeth");
    }
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    //set int values to the text field inputs
    module = [moduleTxt.text floatValue];
    teethWheel = [wheelTeethTxt.text intValue];

    //set all backgrounds to white
    moduleTxt.backgroundColor = [UIColor whiteColor];
    wheelTeethTxt.backgroundColor = [UIColor whiteColor];

    //set backgrounds to yellow if had to correct
    moduleTxt.textColor=[UIColor blackColor];
    if (module<0.1) {
        moduleTxt.textColor=[UIColor redColor];
        module=0.1;
        moduleTxt.text=@"0.1";
        moduleTxt.backgroundColor = [UIColor yellowColor];
    }
    if (teethWheel>600) {
        wheelTeethTxt.textColor=[UIColor redColor];
        teethWheel=600;
        wheelTeethTxt.text=@"600";
        wheelTeethTxt.backgroundColor = [UIColor yellowColor];
    }
    if (module>9.0) {
        moduleTxt.textColor=[UIColor redColor];
        module=9.0;
        moduleTxt.text=@"9.0";
        moduleTxt.backgroundColor = [UIColor yellowColor];
    }
    if (teethWheel<4) {
        wheelTeethTxt.textColor=[UIColor redColor];
        teethWheel=4;
        wheelTeethTxt.text=@"4";
        wheelTeethTxt.backgroundColor = [UIColor yellowColor];
    }
    [self calculateBtn:self];
}
@end
