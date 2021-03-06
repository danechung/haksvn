<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<script type="text/javascript">
	$(function() {
    	$('#menu .<c:out value="${selectedMenuNameLevel1}" />').addClass('selected');
    	$('#submenu .module .<c:out value="${selectedMenuNameLevel2}" />').addClass('selected');
    	$('#submenu .<c:out value="${selectedMenuNameLevel1}" />').removeClass('modules_left_hidden').addClass('modules_left');
    	$('#menu a').click(function(){
    		if( $(this).hasClass('selected') ) return;
    		$('#submenu .submenuList').removeClass('modules_left').addClass('modules_left_hidden');
    		$('#submenu .' + String(this.className)).removeClass('modules_left_hidden').addClass('modules_left');
    		$('#menu a').removeClass('selected');
    		$(this).addClass('selected');
    	});
   	});
</script>
<div id="menu">
	<div id="left"></div>
	<div id="right"></div>
	<ul>
		<c:forEach items="${menuList}" var="menuLevel1">
			<li><a class="<c:out value="${menuLevel1.menuName}" />"><span><c:out value="${menuLevel1.menuName}" /></span></a></li>
		</c:forEach>
	</ul>
	<div class="clear"></div>
</div>

<div id="submenu">
	<c:forEach items="${menuList}" var="menuLevel1" >
		<div class="modules_left_hidden <c:out value="${menuLevel1.menuName}" /> submenuList">
			<div class="module buttons">
				<c:forEach items="${menuLevel1.subMenuList}" var="menuLevel2" >
					<a href="<c:url value="${menuLevel2.menuUrl}"/>" class="dropdown_button <c:out value="${menuLevel2.menuName}" />">
						<span><c:out value="${fn:replace(menuLevel2.menuName,'_',' ')}" /></span>
					</a>
				</c:forEach>
			</div>
		</div>
	</c:forEach>
</div>
