<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib"%>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib"%>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions"%>
<%@ taglib prefix="visibility" uri="http://www.jahia.org/tags/visibilityLib"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="uiComponents"
  uri="http://www.jahia.org/tags/uiComponentsLib"%>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib"%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<jsp:useBean id="now" class="java.util.Date"/>

<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js,admin-bootstrap.js,bootstrap-filestyle.min.js,jquery.metadata.js,jquery.tablesorter.js,jquery.tablecloth.js"/>
<template:addResources type="css" resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css,tablecloth.css"/>
<template:addResources type="javascript" resources="datatables/jquery.dataTables.js,i18n/jquery.dataTables-${currentResource.locale}.js,datatables/dataTables.bootstrap-ext.js"/>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function() {
        var providersTable = $('#visibilityContentTable');

        providersTable.dataTable({
            "sDom": "<'row-fluid'<'span6'l><'span6 text-right'f>r>t<'row-fluid'<'span6'i><'span6 text-right'p>>",
            "iDisplayLength": 5,
            "sPaginationType": "bootstrap",
            "aaSorting": [] //this option disable sort by default, the user steal can use column names to sort the table
        });
      
    });
  
  	
</script>


<c:set var="site" value="${renderContext.mainResource.node.resolveSite}" />

<h2>
  <fmt:message key="siteSettings.label.visibilityDashboardTitle" />
  - ${fn:escapeXml(site.displayableName)}
</h2>
<c:set var="count" value="0" scope="page" />
<div class="box-1">
  
  <c:if test="${not empty visibilityContentList}">
    
    <table id="visibilityContentTable"
           class="table table-striped table-bordered">
      <thead>
        <tr>
          <th width="3%">#</th>
          <th width="10%"><fmt:message
                                       key="visibilityDashboard.table.page" /></th>
          <th width="35%"><fmt:message
                                       key="visibilityDashboard.table.content" /></th>
          <th width="23%"><fmt:message
                                      key="visibilityDashboard.table.condition" /></th>
          <th width="20%"><fmt:message
                                       key="visibilityDashboard.table.status" /><br/>
            <fmt:setLocale value="${currentResource.locale}" />
            <fmt:formatDate value="${now}" type="both" dateStyle="full" timeStyle="medium"/></th>
        </tr>
      </thead>
      <tbody>
        
        <c:forEach items="${visibilityContentList}" var="visibilityContent" varStatus="status">
          
          <template:addCacheDependency node="${visibilityContent}" />
          
          <tr>
            <td width="3%">
              <c:set var="count" value="${count + 1}" scope="page" />
              <c:out value="${count}" />
            </td>
            <td width="10%">
              <c:set var="pageNode" value="${jcr:getParentsOfType(visibilityContent, 'jnt:page')}"/>
              <a href='<c:url value="${url.base}${pageNode[0].path}.html"/>' target="_blank" title="view ${visibilityContent.parent.displayableName} in context">
                <c:out value="${pageNode[0].displayableName}" />
              </a>
            </td>
            <td width="35%">
              <c:out value="${visibilityContent.parent.displayableName}" /> (<i><c:out value="${visibilityContent.parent.primaryNodeTypeName}" /></i>)
            	
              
              <button type="button"
                      class="btn btn-primary btn-${visibilityContent.parent.UUID}"
                      id="btn-${visibilityContent.parent.UUID}" data-toggle="modal"
                      data-target="#${visibilityContent.parent.UUID}" style="float:right">
                <i class="icon-info-sign icon-white"></i><span><fmt:message key="visibilityDashboard.viewContent" /></span>
              </button>
              
                        <!-- Modal -->
								<div class="modal fade" id="${visibilityContent.parent.UUID}" tabindex="-1"
									role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal"
													aria-hidden="true">&times;</button>
												<template:module node="${visibilityContent.parent}" editable="false"/>
												<button type="button" class="btn btn-default"
													data-dismiss="modal">Close</button>

											</div>
										</div>
									</div>
								</div>
            </td>
            <td width="23%">
              <c:forEach items="${visibilityContent.nodes}" var="subchild">
                <c:if test="${jcr:isNodeType(subchild, 'jnt:startEndDateCondition')}">
                  <li> <b><fmt:message key="visibilityDashboard.startEndDate" /></b>
                    <jcr:nodeProperty node="${subchild}" name="start" var="start"/>
                    <jcr:nodeProperty node="${subchild}" name="end" var="end"/>
                    <c:if test="${not empty start}">
                      <fmt:message key="visibilityDashboard.from" />
                      <fmt:formatDate type="date" value="${start.date.time}" />
                    </c:if>
                    
                    <c:if test="${not empty end}">
                      &nbsp;<fmt:message key="visibilityDashboard.to" />
                      <fmt:formatDate type="date" value="${end.date.time}" />
                    </c:if>
                    
                    
                  </li>
                </c:if>
                <c:if test="${jcr:isNodeType(subchild, 'jnt:dayOfWeekCondition')}">
                  <li> <b><fmt:message key="visibilityDashboard.dayOfWeek" /></b>
                    <jcr:nodeProperty node="${subchild}" name="dayOfWeek" var="dayOfWeek"/>
                    <c:forEach items="${dayOfWeek}" var="day">
                      <c:out value="${day.string}" />,
                    </c:forEach>
                  </li>
                </c:if>
                <c:if test="${jcr:isNodeType(subchild, 'jnt:timeOfDayCondition')}">
                  <li> <b><fmt:message key="visibilityDashboard.timeOfDay" /></b>
                    <jcr:nodeProperty node="${subchild}" name="startHour" var="startHour"/>
                    <jcr:nodeProperty node="${subchild}" name="startMinute" var="startMinute"/>
                    <jcr:nodeProperty node="${subchild}" name="endHour" var="endHour"/>
                    <jcr:nodeProperty node="${subchild}" name="endMinute" var="endMinute"/>
                    <c:if test="${not empty startHour}">
                      <fmt:message key="visibilityDashboard.fromHour" />
                      <c:out value="${startHour.string}:${startMinute.string}" />
                    </c:if>
                    <c:if test="${not empty endHour}">
                      &nbsp;<fmt:message key="visibilityDashboard.toHour" />
                      <c:out value="${endHour.string}:${endMinute.string}" />
                    </c:if>
                    
                  </li>
                </c:if>
              </c:forEach>
              
            </td>
            <td width="20%"  style="text-align: center;vertical-align: middle;">
              
              <c:choose>
                <c:when test="${visibility:getVisibilityStatus(visibilityContent.parent)}">
                  <img src="<c:url value='${url.currentModule}/img/visibilityStatusGreen.png'/>" />
                </c:when>
                <c:otherwise>
                  <img src="<c:url value='${url.currentModule}/img/visibilityStatusRed.png'/>" />
                </c:otherwise>
              </c:choose>
              
              
            </td>
          </tr>
          
                        
									
        </c:forEach>
      </tbody>
    </table>
  </c:if>
  <c:if test="${empty visibilityContentList}">
    <div class="alert alert-info">
      <h2><fmt:message key='visibilityDashboard.noContent' /></h2>
    </div>
  </c:if>
</div>



</div>



