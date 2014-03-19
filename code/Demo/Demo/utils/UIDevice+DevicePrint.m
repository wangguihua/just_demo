#import <AddressBook/AddressBook.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreLocation/CoreLocation.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <netinet/ip.h>
#include <sys/sysctl.h>
#import "UIDevice+DevicePrint.h"
#import "NSStringAdditions.h"

#define BUFFERSIZE  4000
#define MAXADDRS 32

@interface MBDevicePrint : NSObject<CLLocationManagerDelegate>

+(id)sharedDevice;
- (NSString*)getDevicePrint;

@property (nonatomic,strong) CLLocationManager *locManager;
@property (nonatomic,strong) NSString* latitudeStr; //纬度
@property (nonatomic,strong) NSString* longitudeStr; // 经度
@property (nonatomic) double horizontalAccuracyDouble; //横向精度的值
@property (nonatomic) double altitudeDouble;//海拔的值
@property (nonatomic, strong) NSString* horizontalAccuracyStr;//横向精度
@property (nonatomic, strong) NSString* altitudeDoubleStr;//海拔
@property (nonatomic,strong) NSString* deviceInfo;
@end

@implementation MBDevicePrint
static MBDevicePrint *sharedDeviceObject = nil;

+(id)sharedDevice{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDeviceObject = [[MBDevicePrint alloc] init];
    });
    return sharedDeviceObject;
}

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

void InitAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
    nextAddr = 0;
}

void FreeAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
}

void GetIPAddresses()
{
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = MAX(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;   // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;      // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;   /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;   // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
}

- (NSString *)deviceIPAdress {
    InitAddresses();
    GetIPAddresses();
    NSString* ipStr = [[NSString alloc] initWithFormat:@"%s",ip_names[1]];
    FreeAddresses();
    return ipStr;
}

- (NSString *) macaddress
{
	int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

- (void)freeMemory{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(freeMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        
        //获取设备信息
        NSString* mac = [NSString stringWithFormat:@"wiFiMacAddress=%@;",[self macaddress]];
        NSString* deviceModel = [NSString stringWithFormat:@"deviceModel=%@;",[[UIDevice currentDevice] model]];
        NSString* screenSize = [NSString stringWithFormat:@"screenSize=%d*%d;",(int)([[UIScreen mainScreen] applicationFrame].size.width*[UIScreen mainScreen].scale),(int)([[UIScreen mainScreen] applicationFrame].size.height*[UIScreen mainScreen].scale)];
        NSString* deviceSystemName = [NSString stringWithFormat:@"deviceSystemName=%@;",[[UIDevice currentDevice] systemName]];
        NSString* deviceSystemVersion = [NSString stringWithFormat:@"deviceSystemVersion=%@;",[[UIDevice currentDevice] systemVersion]];
        
        NSString* deviceMultiTaskingSupported = @"deviceMultiTaskingSupported=";
        if ([UIDevice currentDevice].multitaskingSupported) {
            deviceMultiTaskingSupported = [deviceMultiTaskingSupported stringByAppendingString:@"true;"];
        }
        NSString* deviceName = [NSString stringWithFormat:@"deviceName=%@;",[[UIDevice currentDevice] name]];
        
        ABAddressBookRef ab = ABAddressBookCreate();
        CFIndex count = ABAddressBookGetPersonCount(ab);
        NSString* numberOfAddressBookEntries = [NSString stringWithFormat:@"numberOfAddressBookEntries=%ld;",count];
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* Languages = [NSString stringWithFormat:@"Languages=%@;",[languages objectAtIndex:0]];
        
        if(ab)
        {
            CFRelease(ab);
        }
        
        NSString* Mcc = @"Mcc=;";
        NSString* Mnc = @"Mnc=;";
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = info.subscriberCellularProvider;
        NSString* carrierStr = [carrier description];
        carrierStr = [carrierStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        carrierStr = [carrierStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        carrierStr = [carrierStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSRange rangeOfMCC = [carrierStr rangeOfString:@"MobileCountryCode:["];
        if (rangeOfMCC.location != NSNotFound) {
            carrierStr = [carrierStr substringFromIndex:rangeOfMCC.location+rangeOfMCC.length];
            NSRange rangeEnd = [carrierStr rangeOfString:@"]"];
            Mcc = [NSString stringWithFormat:@"Mcc=%@;",[carrierStr substringToIndex:rangeEnd.location]];
            
            carrierStr = [carrierStr substringFromIndex:rangeEnd.location+rangeEnd.length];
            NSRange rangeOfMNC = [carrierStr rangeOfString:@"MobileNetworkCode:["];
            if (rangeOfMNC.location != NSNotFound) {
                carrierStr = [carrierStr substringFromIndex:rangeOfMNC.location+rangeOfMNC.length];
                rangeEnd = [carrierStr rangeOfString:@"]"];
                Mnc = [NSString stringWithFormat:@"Mnc=%@;",[carrierStr substringToIndex:rangeEnd.location]];
            }
        }
        //获取经纬度、横向精度、海拔
        _locManager = [[CLLocationManager alloc] init];
        [_locManager setDelegate:self];
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        self.latitudeStr = @"";
        self.longitudeStr = @"";
        self.horizontalAccuracyDouble = 0.0;
        self.horizontalAccuracyStr = @"";
        self.altitudeDouble = 0.0;
        self.altitudeDoubleStr = @"";
        self.deviceInfo = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",mac,deviceModel,screenSize,deviceSystemName,deviceSystemVersion,deviceMultiTaskingSupported,deviceName,numberOfAddressBookEntries,Languages,Mcc,Mnc];
    }
    return self;
}

//获取经纬度、横向精度、海拔代理
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    
    if ([newLocation.timestamp timeIntervalSinceNow] < 60) {
        //        NSLog(@"device location stop");
        [manager stopUpdatingLocation];
        CLLocationCoordinate2D loc = [newLocation coordinate];
        
        if(self.latitudeStr)
        {
            self.latitudeStr = nil;
        }
        if (self.longitudeStr) {
            self.longitudeStr = nil;
        }
        if(self.horizontalAccuracyStr)
        {
            self.horizontalAccuracyStr = nil;
        }
        if (self.altitudeDoubleStr) {
            self.altitudeDoubleStr = nil;
        }
        self.latitudeStr =[NSString stringWithFormat:@"%f",loc.latitude];//get latitude
        self.longitudeStr =[NSString stringWithFormat:@"%f",loc.longitude];//get longitude
        
        if (newLocation.horizontalAccuracy < 0 || newLocation.verticalAccuracy < 0){
            self.horizontalAccuracyDouble = 0.0;
            self.altitudeDouble = 0.0;
            self.horizontalAccuracyStr = @"";
            self.altitudeDoubleStr = @"";
            return;
        }
        
        if (self.horizontalAccuracyDouble == 0.0 || self.horizontalAccuracyDouble > newLocation.horizontalAccuracy) {
            self.horizontalAccuracyDouble = newLocation.horizontalAccuracy;
            self.horizontalAccuracyStr = [NSString stringWithFormat:@"%f",self.horizontalAccuracyDouble];
        }
        
        CLLocationDistance altitude = newLocation.altitude;
        self.altitudeDouble = altitude;
        self.altitudeDoubleStr = [NSString stringWithFormat:@"%f",self.altitudeDouble];
    }
}

- (NSString *)getDevicePrint{
    //只询问用户一次地理位置请求
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized) {
        [_locManager startUpdatingLocation];
    }
    
    NSDate *localDate = [NSDate date];
    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSince1970];
    NSString* timeStamp = [NSString stringWithFormat:@"%f",gmtTimeInterval];
    NSRange rangPoint = [timeStamp rangeOfString:@"."];
    timeStamp = [NSString stringWithFormat:@"%@%@",[timeStamp substringToIndex:rangPoint.location],[[timeStamp substringFromIndex:rangPoint.location + rangPoint.length] substringToIndex:3]];//得到以这毫秒为精度的时间戳
    NSString* deviceIPAdd = [self deviceIPAdress];
    NSString* deviceInfoStr = [NSString stringWithFormat:@"%@Longitude=%@;Latitude=%@;horizontalAccuracy=%@;Timestamp=%@;Altitude=%@X-Forwarded-For=%@",self.deviceInfo,self.longitudeStr,self.latitudeStr,self.horizontalAccuracyStr,timeStamp,self.altitudeDoubleStr,deviceIPAdd];
    NSLog(@"d print_____________________ ===%@",deviceInfoStr);
    return [deviceInfoStr urlEncoded];
}

- (void)dealloc{
    MB_RELEASE_SAFELY(_locManager);
    
}
@end






@implementation UIDevice (DevicePrint)

- (NSString *)devicePrint{
    MBDevicePrint *print = [MBDevicePrint sharedDevice];
    return [print getDevicePrint];
}

- (void)updateLocation
{
    MBDevicePrint *print = [MBDevicePrint sharedDevice];
    [print.locManager startUpdatingLocation];
}
/**
 * 设备信息用来区别终端特性，建议格式：“厂商名,产品名,型号”;
 * 如果是基于浏览器的RIA应用，则填写浏览器信息，建议格式：“厂商名,产品名,版本号”
 */
- (NSString *)requestHeaderDevice
{
    NSString * manufacturer, * productName, * deviceVersion;
    
    manufacturer = @"Apple";
    productName = [[UIDevice currentDevice] model];
    deviceVersion = [self getDeviceVersion];
    
    return [NSString stringWithFormat:@"%@,%@,%@", manufacturer, productName, deviceVersion];
}

- (NSString *)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 * 操作系统信息,建议格式：“厂商名,产品名,版本号”
 */
- (NSString *)requestHeaderPlatform
{
    NSString * manufacturer, * productName, * sdkVersion;
    
    manufacturer = @"Apple";
    productName = [[UIDevice currentDevice] systemName];
    sdkVersion = [[UIDevice currentDevice] systemVersion];
    
    return [NSString stringWithFormat:@"%@,%@,%@", manufacturer, productName, sdkVersion];
}

/**
 * 版本号
 */
- (NSString *)requestHeaderVersion
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *kVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    return kVersion;
}

@end