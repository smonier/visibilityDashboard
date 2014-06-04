<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib"%>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib"%>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions"%>
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

<template:addResources type="css" resources="moderateMessages.css" />
<template:addResources type="javascript"
	resources="jquery.min.js,jquery-ui.min.js,jquery.blockUI.js,workInProgress.js,admin-bootstrap.js,jquery.dataTables.min.js" />
<template:addResources type="css"
	resources="admin-bootstrap.css,bootstrap.min.css" />
<template:addResources type="css"
	resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css" />

<script>



	$(document)
			.ready(
					function() {

						$('.data-table').dataTable({
                            "sDom" : "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
                            "aLengthMenu": [[5, 10, 50, 100, -1], [5, 10, 50, 100, 'All']],
                         	"sPaginationType": "full_numbers",
                            "iDisplayLength" : 5
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
				class="table table-bordered table-striped table-hover display data-table">
				<thead>
					<tr>
						<th width="3%">#</th>
						<th width="45%"><fmt:message
								key="visibilityDashboard.table.page" /></th>
						<th width="10%"><fmt:message
								key="visibilityDashboard.table.content" /></th>
						<th width="8%"><fmt:message
								key="visibilityDashboard.table.condition" /></th>
						<th width="34%"><fmt:message
								key="visibilityDashboard.table.status" /></th>
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
                                <td width="25%">
                                    <c:set var="pageNode" value="${jcr:getParentsOfType(visibilityContent, 'jnt:page')}"/>
                                    <a href='<c:url value="${url.base}${pageNode[0].path}.html"/>' target="_blank">
                                        <c:out value="${pageNode[0].displayableName}" />
                                    </a>
                                </td>
                                <td width="25%">
                                    <c:out value="${visibilityContent.parent.displayableName}" />
                                </td>
                                <td width="27%">
                                     <c:forEach items="${visibilityContent.nodes}" var="subchild">
                                                <c:if test="${jcr:isNodeType(subchild, 'jnt:startEndDateCondition')}">
                                                    <li> <b>Start and End Date: </b>
                                                        <jcr:nodeProperty node="${subchild}" name="start" var="start"/>
                                                        <jcr:nodeProperty node="${subchild}" name="end" var="end"/>
                                                        From <fmt:formatDate type="date" value="${start.date.time}" /> to
                                                        <fmt:formatDate type="date" value="${end.date.time}" />

                                                    </li>
                                                </c:if>
                                                <c:if test="${jcr:isNodeType(subchild, 'jnt:dayOfWeekCondition')}">
                                                    <li> <b>Day of the Week: </b>
                                                        <jcr:nodeProperty node="${subchild}" name="dayOfWeek" var="dayOfWeek"/>
                                                        <c:forEach items="${dayOfWeek}" var="day">
                                                            <c:out value="${day.string}" />,
                                                        </c:forEach>
                                                    </li>
                                                </c:if>
                                                 <c:if test="${jcr:isNodeType(subchild, 'jnt:timeOfDayCondition')}">
                                                    <li> <b>Time of the Day: </b>
                                                        <jcr:nodeProperty node="${subchild}" name="startHour" var="startHour"/>
                                                        <jcr:nodeProperty node="${subchild}" name="startMinute" var="startMinute"/>
                                                        <jcr:nodeProperty node="${subchild}" name="endHour" var="endHour"/>
                                                        <jcr:nodeProperty node="${subchild}" name="endMinute" var="endMinute"/>
                                                        From  <c:out value="${startHour.string}:${startMinute.string}" />  to <c:out value="${endHour.string}:${endMinute.string}" />
                                                    </li>
                                                </c:if>
                                     </c:forEach>

                                </td>
                                <td width="10%"></td>
                            </tr>


							<jcr:nodeProperty node="${forumPost}" name="jcr:title"
								var="commentTitle" />
							<jcr:nodeProperty node="${forumPost.parent}" name="topicSubject"
								var="topicSubject" />
							<jcr:nodeProperty node="${forumPost.parent.parent}"
								name="jcr:title" var="sectionTitle" />
							<jcr:nodeProperty node="${forumPost}" name="jcr:createdBy"
								var="createdBy" />
							<jcr:nodeProperty node="${forumPost}" name="content"
								var="content" />





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



