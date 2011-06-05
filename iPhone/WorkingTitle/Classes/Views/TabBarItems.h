/*
 *  TabBarItems.h
 *  WorkingTitle
 *
 *  Created by Jerome Lecomte on 11-06-05.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

// Order in which these items appear in the main tab bar.
// New buttons on startup screen and items in main tab bar have their tag set to these values
typedef enum {
	TabBarItemEstimates = 1,
	TabBarItemContracts,
	TabBarItemOptions,

	numTabBarItem
} TabBarItems;