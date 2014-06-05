package org.jahia.modules.visibility.tags;

import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.visibility.VisibilityService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Created by smonier on 05/06/14.
 */
public class visibilityFunctions {

    private static final Logger logger = LoggerFactory.getLogger(visibilityFunctions.class);


    public static boolean getVisibilityStatus(JCRNodeWrapper NodeWrapper) {
        return VisibilityService.getInstance().matchesConditions(NodeWrapper)   ;
    }


}