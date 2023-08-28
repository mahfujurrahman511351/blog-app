const baseUrl = "http://10.0.2.2:3000/api/v1/user"; // bluestack local ip
// const baseUrl = "http://domainhere.com/api/v1/user";   // server url

const imageBaseUrl = "http://10.0.2.2:3000/"; // bluestack
// const imageBaseUrl = "http://domainhere.com/";  // server

//authentication
const loginApi = "$baseUrl/login";
const registerApi = "$baseUrl/register";
const checkResetPassApi = "$baseUrl/check-reset-pass";
const resetPassApi = "$baseUrl/reset-pass";

//home
const categoriesApi = "$baseUrl/category-all";
const getPostsApi = "$baseUrl/post-all";
const createPostsApi = "$baseUrl/post-create";
const editPostsApi = "$baseUrl/post-edit";
const likeUnlikeApi = "$baseUrl/like-unlike/";
