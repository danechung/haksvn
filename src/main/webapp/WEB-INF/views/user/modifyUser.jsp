<%@ include file="/WEB-INF/views/common/include/taglib.jspf"%>
<script type="text/javascript">
	$(function() {
		var pathname = window.location.pathname;
		actionUrl = pathname.replace('/save','') + '/save';
		$('#frm_user').attr('action', actionUrl);
		setFormValidation();
   	});
	
	function setFormValidation(){
		$("#frm_user").validate({
			rules: {
				userId:{
					required: true,
					minlength: 3,
					maxlength: 20,
					remote:{
                      url: "<c:url value="/configuration/users/add/validateUserId/"/>",
                      data:{
                          userId: function(){
                              return $("#frm_user input[name=userId]").val();
                          }
                      }
                    }
				},
				userName: {
					required: true,
					minlength: 4,
					maxlength: 50
				},
				email: {
					required: true,
					email: true
				},
				userPasswd: {
					required: true,
					minlength: 4,
					maxlength: 50
				}
			},
			messages: {
				userId:{
					remote: $.validator.format("<spring:message code="validation.duplicate" />")
				}
				
			}
		});
	};
	
</script>
<div class="content-page">
	<h1>User Information</h1>
	<div class="col w10 last">
		<div class="content">
			<form:form commandName="user" class="w200" id="frm_user" method="post">
					<form:hidden path="userSeq" name="userSeq"/>
					<c:if test="${user.userSeq lt 1}" var="isNewUser" />
				<p>
					<form:label path="userId" class="left">User ID</form:label>
					<c:choose>
						<c:when test="${isNewUser}">
							<form:input class="text w_10" path="userId"/>
						</c:when>
						<c:otherwise>
							<form:input class="text w_10 readOnly" path="userId" readonly="true" />
							<script type="text/javascript">
								$(function() {
									$("#frm_user input[name=userId]").rules("remove","remote");
								});
							</script>
						</c:otherwise>
					</c:choose>
					<form:errors path="userId" />
					<span class="form-status"></span>
				</p>
				<p>
					<form:label path="userName" class="left">User Name</form:label>
					<form:input class="text w_200" path="userName" />
					<form:errors path="userName" />
					<span class="form-status"></span>
				</p>
				<p>
					<form:label path="email" class="left">Email</form:label>
					<form:input class="text w_200" path="email"/>
					<form:errors path="email" />
					<span class="form-status"></span>
				</p>
				<p>
					<form:label path="userPasswd" class="left">Password</form:label>
					<form:password class="text w_150" path="userPasswd"/>
					<form:errors path="userPasswd" />
					<span class="form-status"></span>
				</p>
				<p>
					<form:label path="authType" class="left">User Authority</form:label>
					<form:select path="authType" items="${requestScope['user.auth.type.code']}" itemValue="codeId" itemLabel="codeName"/>
					<span class="form-help"><spring:message htmlEscape="true" code="helper.user.authType" /></span>
				</p>
				<p>
					<form:label path="active" class="left">Active</form:label>
					<form:select path="active" items="${requestScope['common.boolean.yn.code']}" itemValue="codeId" itemLabel="codeName"/>
				</p>
				<p>
					<label class="left"></label>
					<a class="button green mt ml form_submit"><small class="icon check"></small><span>Confirm</span></a>
					<c:if test="${not isNewUser}">
						<a class="button red mt ml" onclick="deleteUser()"><small class="icon cross"></small><span>Delete</span></a>
						<script type="text/javascript">
							$(function() {
								$("#frm_user input[name=userPasswd]").rules( "remove", "required" );
							});
							function deleteUser(){
								$('#frm_user').attr('action', $('#frm_user').attr('action').replace('save','delete'));
								frm_user.submit();
							};
							
						</script>
					</c:if>
				</p>
			</form:form>
		</div>
	</div>
	<div class="clear"></div>
</div>