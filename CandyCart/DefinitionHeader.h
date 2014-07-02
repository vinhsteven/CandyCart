//
//  DefinitionHeader.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/19/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

//#define AT_SHOP //chi danh cho cac loai hinh cho phep dat ban tai cho nhu: cafe, nha hang...

//#define BG_WHITE
//#define ishop
//#define ibar
//#define ipub
//#define tintincafe
//#define khobom
//#define saigoncafe
//#define highlandcafe
//#define mollycafe
//#define ontheradio
//#define mokacafe
#define thefaceshop

//Your Wordpress URL Should Be Here

//#define MAIN_URL @"http://nhuanquang.com/traphuson"
//#define ROOT_ACCOUNT @"vinhsteven" //root account for this database

#define GUEST_USER  @"guest"
#define GUEST_PASS  @"abc123"

#define BUY_METHOD @"BuyMethod" //buy as user / guest

#define MAIN_URL_HTTPS @"" //Leave empty if you didn't install any SSL in your server e.g https://candycart.appress.me/

//GLOBAL FONT
/*
 NOTE : You need to update your font HERE AND "CandyTheme_IOS7.NUI/CandyTheme_IOS6.NUI".
 */
#define PRIMARYFONT @"HelveticaNeue-Light"
#define BOLDFONT @"Helvetica"

//To Change a color you can go to CandyTheme.NUI


//Wordpress Post Per load
#define WP_POST_PER_PAGE @"10" //How much will load per query

//WooCommerce Product Per load @ Effect in BrowseDetailController
#define WOO_PRODUCT_PERPAGE @"10" //How much will load per query

//Push Notification per load @ Effect in Right Swipe
#define PUSH_NOTTIFICATION_PERPAGE @"30" //How much will load per query

//Set Notification delay before Hide
#define NOTIFICATION_DELAY 10.0

//Enable Multilevel Comment
//1 : No Multilevel
//2 : Will enable 1st Level Only
//3 : Will enable Infinite Level

#define ENABLE_MULTILEVEL_COMMENT 2


//UIWEBView Header Setting. Will effect in UIWebView Page detail and post detail. Please put your JS/CSS file in JS folder
// You can use URL if you want but will effect the load performance... e.g JQUERY @"http://codeorigin.jquery.com/jquery-2.0.3.min.js"

#define JQUERY @"js/jquery-2.0.2.min.js"
#define BOOTSTRAP_CSS @"js/bootstrap.min.css"
#define BOOTSTRAP_JS @"js/bootstrap.min.js"
#define SWIPER_JS @"js/idangerous.swiper-2.0.min.js"
#define SWIPER_JS_3D_FLOW @"js/idangerous.swiper.3dflow-2.0.js"
#define SWIPER_JS_SCROLLBAR @"js/idangerous.swiper.scrollbar-2.0.js"

#define SWIPER_CSS @"js/idangerous.swiper.css" 
#define SWIPER_CSS_3D @"js/idangerous.swiper.3dflow.css" 
#define SWIPER_CSS_SCROLLBAR @"js/idangerous.swiper.scrollbar.css" 

#define CUSTOM_JS @""                   //Leave empty if you dont have any custom JS
#define BOOTSTRAP_THEME @""             //Leave empty if you dont have any theme

#define CUSTOM_CSS @"" 
#define CUSTOM_CSS_FILE @""

#define GENERAL_UIWEBVIEW_FONT_SIZE @"14px"

//............................................................

#define AddToCartQuantityMax 15 // Will not effect if a product "enable Inventory"
#define GenieAnimationSpeedDuration 1.1

//Version
#define APP_VERSION 1.5
#define WP_CANDY_CART_PLUGIN_VERSION 1.3 // Mean - This source code compatible with this plugin version



