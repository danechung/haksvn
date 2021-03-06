package com.haks.haksvn.source.controller;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haks.haksvn.common.exception.HaksvnException;
import com.haks.haksvn.common.message.model.ResultMessage;
import com.haks.haksvn.common.paging.model.Paging;
import com.haks.haksvn.common.security.util.ContextHolder;
import com.haks.haksvn.source.model.Review;
import com.haks.haksvn.source.model.ReviewComment;
import com.haks.haksvn.source.model.ReviewId;
import com.haks.haksvn.source.model.ReviewRequest;
import com.haks.haksvn.source.service.ReviewService;
import com.haks.haksvn.user.model.User;
import com.haks.haksvn.user.service.UserService;

@Controller
@RequestMapping(value="/source")
public class ReviewAjaxController {

	@Autowired
	private ReviewService reviewService;
	@Autowired
	private UserService userService;
    
	@RequestMapping(value={"/review/{repositoryKey}/{revision}"}, method=RequestMethod.POST)
    public @ResponseBody ResultMessage saveReview(@PathVariable String repositoryKey,
    												@PathVariable long revision,
    												@ModelAttribute("review") Review review) throws Exception{
		ResultMessage message = new ResultMessage("Save Review success");
		reviewService.saveReview(Review.Builder.getBuilder(review).reviewId(ReviewId.Builder.getBuilder().repositoryKey(repositoryKey).revision(revision)
					.reviewer(userService.retrieveUserByUserId(ContextHolder.getLoginUser().getUserId())).build()).build());
		return message;
    }
	
	@RequestMapping(value={"/review/{repositoryKey}/{revision}/comment/{reviewCommentSeq}"}, method=RequestMethod.DELETE)
    public @ResponseBody ResultMessage saveReview(@PathVariable String repositoryKey,
    												@PathVariable long revision,
    												@PathVariable int reviewCommentSeq) throws Exception{
		ResultMessage message = new ResultMessage("Review comment deleted");
		reviewService.deleteReviewComment(ReviewComment.Builder.getBuilder().reviewCommentSeq(reviewCommentSeq).build());
		return message;
    }
	
	@RequestMapping(value="/review/{repositoryKey}/{revision}/request", method=RequestMethod.POST)
    public @ResponseBody ResultMessage requestReview(@PathVariable String repositoryKey,
    												@PathVariable long revision,
    												@RequestParam(value = "userId", required = true) String[] userIdList){
    	
    	ResultMessage message = new ResultMessage("Request Review success");
    	reviewService.requestReview(ReviewId.Builder.getBuilder().repositoryKey(repositoryKey).revision(revision).build(), userIdList);
    	return message;
    }
	
	@RequestMapping(value="/reviewRequest/list/{repositoryKey}", headers="Accept=application/json")
    public @ResponseBody Paging<List<ReviewRequest>> retrieveReviewRequestList(@ModelAttribute("paging") Paging<ReviewRequest> paging,
										    		@RequestParam(value = "rUser", required = false, defaultValue="") String reviwerId,
													@RequestParam(value = "qUser", required = false, defaultValue="") String requestorId,
													@PathVariable String repositoryKey) throws HaksvnException {
    	ReviewRequest reviewRequest = ReviewRequest.Builder.getBuilder().repositoryKey(repositoryKey)
    			.requestor(User.Builder.getBuilder().userId(requestorId).build())
    			.reviewers(Arrays.asList(User.Builder.getBuilder().userId(reviwerId).build())).build();
    	paging.setModel(reviewRequest);
    	Paging<List<ReviewRequest>> reviewRequestListPaging = reviewService.retrieveReviewRequestList(paging);
    	return reviewRequestListPaging;
    }
	
	@ExceptionHandler(Exception.class)
    public void exceptionHandler(Exception e, HttpServletResponse response) throws Exception{
    	e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write(e.getMessage());
        response.flushBuffer();
    }
}
