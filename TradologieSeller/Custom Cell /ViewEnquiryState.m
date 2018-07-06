//
//  ViewEnquiryState.m
//  Tradologie
//
//  Created by Chandresh Maurya on 13/06/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "ViewEnquiryState.h"
#import "CommonUtility.h"

@implementation ViewEnquiryState

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        
    }
    return self;
}
-(void)setDataDict:(SellerAuctionDetail *)dataDict
{
    [lblNegotiationCode setText:dataDict.AuctionCode];
    [lblNegotiationName setText:[dataDict.AuctionName capitalizedString]];
    lblNegotiationName.numberOfLines = 1;
    lblNegotiationName.minimumScaleFactor = 8./lblNegotiationName.font.pointSize;;
    lblNegotiationName.adjustsFontSizeToFitWidth = YES;
    
    ([dataDict.PortOfDischarge isEqualToString:@""])?[lblPortDischarge setText:@"N.A"]
    :[lblPortDischarge setText:[dataDict.PortOfDischarge capitalizedString]];
    [lblStateofDelivery setText:dataDict.DeliveryState];
    [lblPaymentTerm setText:dataDict.PaymentTerm];
    [lblCurrency setText:dataDict.CurrencyCode];
    [lblStatus setText:dataDict.Status];
    
     NSString *strStartDate = [CommonUtility getDateFromSting:dataDict.StartDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
    
    ([dataDict.StartDate isEqualToString:@""])?[lblStartDate setText:@"N.A"]
    :[lblStartDate setText:strStartDate];
    
    NSString *strEndDate = [CommonUtility getDateFromSting:dataDict.EndDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
    
    ([dataDict.EndDate isEqualToString:@""])?[lblEndDate setText:@"N.A"]
    :[lblEndDate setText:strEndDate];
    
    NSString *strDeliveryLastDate = [CommonUtility getDateFromSting:dataDict.deliveryLastDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy"];
    [lblDateofDelivery setText:strDeliveryLastDate];
    
    [lblPartialDelivery setText:dataDict.PartialDelivery];
    
    NSString *strPreferredDate = [CommonUtility getDateFromSting:dataDict.PreferredDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
    [lblPrefferedDate setText:strPreferredDate];
    
    [lblTotalQty setText:[NSString stringWithFormat:@"%@",dataDict.TotalQuantity]];
    [lblMinOrder setText:[NSString stringWithFormat:@"%@",dataDict.MinQuantity]];
    [lblBankName setText:@""];
    [lblDeliveryLocation setText:dataDict.LocationOfDelivery];
    NSString * newReplacedString = [dataDict.Remarks stringByReplacingOccurrencesOfString:@"\r\n" withString:@". "];    
    [lblRemarks setText:newReplacedString];
    
}

@end
