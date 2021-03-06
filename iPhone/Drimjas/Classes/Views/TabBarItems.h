/*
 *  TabBarItems.h
 *  Drimjas
 *
 *  Created by Jerome Lecomte on 11-06-05.
 *  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
 *
 */

// Order in which these items appear in the main tab bar.
// New buttons on startup screen and items in main tab bar have their tag set to these values
typedef enum {
	TabBarItemEstimates = 1,
	TabBarItemContracts,
    TabBarItemInvoices,
	TabBarItemOptions,

	numTabBarItem
} TabBarItems;