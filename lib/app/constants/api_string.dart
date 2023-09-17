const baseUrl = "http://10.0.2.2:3000/api/v1/user"; // bluestack local ip
// const baseUrl = "http://domainhere.com/api/v1/user";   // server url

const imageBaseUrl = "http://10.0.2.2:3000/"; // bluestack
// const imageBaseUrl = "http://domainhere.com/";  // server

//profile
const profileApi = baseUrl;
const updateProfileApi = "$baseUrl/update-profile";
//authentication
const loginApi = "$baseUrl/login";
const registerApi = "$baseUrl/register";
const checkResetPassApi = "$baseUrl/check-reset-pass";
const resetPassApi = "$baseUrl/reset-pass";
const updatePassApi = "$baseUrl/update-pass";

//home
const categoriesApi = "$baseUrl/category-all";
const getPostsApi = "$baseUrl/post-all";
const getMyPostsApi = "$baseUrl/my-posts";
const createPostsApi = "$baseUrl/post-create";
const editPostsApi = "$baseUrl/post-edit";
const likeUnlikeApi = "$baseUrl/like-unlike/";
const deletePostApi = "$baseUrl/delete-post/";
const deletePostPermanentApi = "$baseUrl/delete-post-permanent/";
const deletedPostsApi = "$baseUrl/deleted-posts";
const getSavedPostsApi = "$baseUrl/get-saved-posts";
const savedPostsApi = "$baseUrl/save-post/";
const restorePostsApi = "$baseUrl/restore-post/";
const removeSavedPostsApi = "$baseUrl/remove-saved-post/";
const postByCategoryApi = "$baseUrl/get-posts-by-category/";
const searchPostApi = "$baseUrl/search-posts/";
//comments
const getCommentApi = "$baseUrl/get-comments/";
const createCommentApi = "$baseUrl/create-comment";
const deleteCommentApi = "$baseUrl/delete-comment/";
//replies
const getRepliesApi = "$baseUrl/get-replies/";
const deleteReplyApi = "$baseUrl/delete-reply/";
const createReplyApi = "$baseUrl/create-reply";
