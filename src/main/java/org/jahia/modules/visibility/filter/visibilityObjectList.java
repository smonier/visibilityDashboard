package org.jahia.modules.visibility.filter;

import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionFactory;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.i18n.LocaleContextHolder;

import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.query.Query;
import javax.jcr.query.QueryManager;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Created by smonier on 04/06/14.
 */
public class visibilityObjectList  extends AbstractFilter {


    private JCRSessionWrapper getSession() throws RepositoryException {
        return getSession(LocaleContextHolder.getLocale());
    }

    private JCRSessionWrapper getSession(Locale locale) throws RepositoryException {
        return JCRSessionFactory.getInstance().getCurrentUserSession("default", locale);
    }

    static final Logger logger = LoggerFactory.getLogger(visibilityObjectList.class);

    public String prepare(RenderContext renderContext, Resource resource, RenderChain chain) {

        // Get SitePath to execute query from it
        String sitePath = renderContext.getMainResource().getNode().getPath().toString();

        final List<JCRNodeWrapper> visibilityContentList = new ArrayList<JCRNodeWrapper>();

        logger.info("Visibility Dashboard for " + sitePath + " ... Listing all Objects");
        try {
            QueryManager qm = getSession().getWorkspace().getQueryManager();
            StringBuilder statement = new StringBuilder("select * from [jnt:conditionalVisibility] as visibilityContent where ISDESCENDANTNODE(visibilityContent,'" + sitePath + "')  order by visibilityContent.['jcr:lastModified'] desc");

            Query q = qm.createQuery(statement.toString(), Query.JCR_SQL2);

            NodeIterator ni = q.execute().getNodes();
            while (ni.hasNext()) {
                JCRNodeWrapper nodeWrapper = (JCRNodeWrapper) ni.next();
                if (nodeWrapper.isNodeType("jnt:conditionalVisibility")) {

                        visibilityContentList.add(nodeWrapper);
                        logger.info("adding Content to List");

                }
            }

            // Save  List in request
            HttpServletRequest request = renderContext.getRequest();
            request.setAttribute("visibilityContentList", visibilityContentList);


        } catch (RepositoryException e) {
            logger.error("Missing information for Visibility Content list Retrieval");
            e.printStackTrace();

        }

        return null;
    }
}