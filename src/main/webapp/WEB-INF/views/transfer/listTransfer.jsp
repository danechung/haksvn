<%@ include file="/WEB-INF/views/common/include/taglib.jspf"%>
<script type="text/javascript">
	$(function() {
		$("#sel_repository option[value='<c:out value="${repositoryKey}" />']").attr('selected', 'selected');
		$("#frm_transfer select[name='rUser'] option[value='<c:out value="${requestUserId}" />']").attr('selected', 'selected');
		$("#frm_transfer select[name='sCode'] option[value='<c:out value="${transferStateCodeId}" />']").attr('selected', 'selected');
		//$("#ipt_path").val('<c:out value="${path}" />');
		if( '<c:out value="${repositoryKey}" />'.length > 0 ) retrieveTransferList();
		
		$("#sel_repository").change(changeRepository);
	});
	
	function changeRepository(){
		$("#frm_transfer").attr('action','<c:url value="/transfer/request/list"/>' + '/' + $("#sel_repository option:selected").val());
		$("#frm_transfer").submit();
	};
	
	function retrieveTransferList(){
		$("#tbl_transferList tfoot span:not(.loading)").removeClass('display-none').addClass('display-none');
		$("#tbl_transferList tfoot span.loader").removeClass('display-none');
		_paging.rUser = $("#frm_transfer select[name='rUser'] option:selected").val();
		_paging.sCode = $("#frm_transfer select[name='sCode'] option:selected").val();
		//_paging.path = $("#ipt_path").val();
		$.post( "<c:url value="/transfer/request/list"/>" + "/" + '<c:out value="${repositoryKey}" />',
				_paging,
				function(data) {
					var transferList = data.model;
					_paging.start = data.start + transferList.length;
					for( var inx = 0 ; inx < transferList.length ; inx++ ){
						var row = $("#tbl_transferList > tbody > .sample").clone();
						//$(row).find(".transferSeq a font").text('req-'+transferList[inx].transferSeq);
						$(row).find(".transferSeq font a").text('req-'+transferList[inx].transferSeq);
						$(row).find(".transferSeq a").attr("href",'<c:url value="/transfer/request/list/${repositoryKey}/"/>' + transferList[inx].transferSeq);
						$(row).children(".transferType").text(transferList[inx].transferTypeCode.codeName);
						$(row).children(".transferState").text(transferList[inx].transferStateCode.codeName);
						$(row).children(".requestor").text(transferList[inx].requestUser.userName);
						$(row).children(".description").text(transferList[inx].description);
						if(transferList[inx].requestDate > 0) $(row).children(".requestDate").text(haksvn.date.convertToEasyFormat(new Date(transferList[inx].requestDate)));
						if(transferList[inx].approveDate > 0) $(row).children(".approveDate").text(haksvn.date.convertToEasyFormat(new Date(transferList[inx].approveDate)));
						if(transferList[inx].transferGroup && transferList[inx].transferGroup.transferDate > 0) $(row).children(".transferDate").text(haksvn.date.convertToEasyFormat(new Date(transferList[inx].transferGroup.transferDate)));
						$(row).removeClass("sample");
						$('#tbl_transferList > tbody').append(row);
					}
					if( transferList.length < 1 ){
						$("#tbl_transferList tfoot span:not(.nodata)").removeClass('display-none').addClass('display-none');
						$("#tbl_transferList tfoot span.nodata").removeClass('display-none');
					}else if( transferList.length < _paging.limit ){
						$("#tbl_transferList tfoot").removeClass('display-none').addClass('display-none');
					}else{
						$("#tbl_transferList tfoot span:not(.showmore)").removeClass('display-none').addClass('display-none');
						$("#tbl_transferList tfoot span.showmore").removeClass('display-none');
					}
					
		},'json');
	};
	
	var _paging = {start:0,limit:15};
</script>

<div class="content-page">
	<div class="col w10 last">
		<div class="content">
			<div class="box">
				<div class="head"><div></div></div>
				<div class="desc search">
					<form id="frm_transfer" method="get">
						<p>
							<label for="sel_repository" class="w_120">Repository Name</label> 
							<select id="sel_repository">
								<c:forEach items="${repositoryList}" var="repository">
									<option value="<c:out value="${repository.repositoryKey}"/>">
										<c:out value="${repository.repositoryName}" />
									</option>
								</c:forEach>
							</select>
							<label for="rUser" class="w_100">Request User</label> 
							<select name="rUser" class="all">
								<c:forEach items="${userList}" var="user">
									<option value="<c:out value="${user.userId}"/>">
										<c:out value="${user.userName}" />
									</option>
								</c:forEach>
							</select>
							<label for="sCode" class="w_50">State</label> 
							<haksvn:select name="sCode" codeGroup="transfer.state.code" selectedValue="${transferStateCodeId}" cssClass="all"></haksvn:select>
							<a class="button right form_submit yellow"><small class="icon looking_glass"></small><span>Search</span></a>
						</p>
						<%--
						<p>
							<label for="path" class="w_120">Source path</label>
							<input id="ipt_path" name="path" type="text" class="text w_60"/>
							<a class="button right form_submit yellow"><small class="icon looking_glass"></small><span>Search</span></a>
						</p>
						 --%>
					</form>
				</div>
				<div class="bottom"><div></div></div>
			</div>
			
			<table id="tbl_transferList">
				<thead>
					<tr>
						<th>ID</th>
						<th>Type</th>
						<th>State</th>
						<th>Requestor</th>
						<th>Description</th>
						<th>Request Date</th>
						<th>Approve Date</th>
						<th>Transfer Date</th>
					</tr>
				</thead>
				<tbody>
					<tr class="sample">
						<td class="transferSeq w_80"><font class="path open-window"><a></a></font></td>
						<td class="transferType w_80"></td>
						<td class="transferState w_70"></td>
						<td class="requestor w_90"></td>
						<td class="description"></td>
						<td class="requestDate w_90" style="text-align:center;"></td>
						<td class="approveDate w_90" style="text-align:center;"></td>
						<td class="transferDate w_90" style="text-align:center;"></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="8" style="text-align:center;">
							<span class="showmore display-none"><font class="path"><a onclick="retrieveTransferList()">Show More</a></font></span>
							<span class="loader display-none"><img src="<c:url value="/images/ajax-loader.gif"/>"/></span>
							<span class="nodata">no data</span>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
	<c:set var="createTransferPathLink" value="${pageContext.request.contextPath}/transfer/request/list/${repositoryKey}/add"/>
	<a href="<c:out value="${createTransferPathLink}"/>" class="button green right"><small class="icon plus"></small><span>Create</span></a>
	<div class="clear"></div>
</div>