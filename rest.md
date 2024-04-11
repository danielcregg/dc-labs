# Wordpress REST API usage  

Before you can use Postman for REST API requests in Wordpress you will need to create an application password.
1. Log in to your WordPress admin dashboard.
2. Go to "Users" -> "Profile".
3. Scroll down to the "Application Passwords" section.
4. Enter a new name for your application (like "Postman") and click "Add New".
5. WordPress will generate a new application password (e.g., vfRY 9k2z tuV5 5W2W vFE7 qix2). Make sure to save this password somewhere safe, as you won't be able to see it again.
    ![image](https://github.com/danielcregg/dc-labs/assets/22198586/cb3fe520-73b4-4548-a6ea-109bafdb024d)
6. Go to Postman, Under Authorization select Basic Auth from the dropdown menu. Beside Username put your Wordpress username (e.g., admin) and beside password put the Application password you just generated above (e.g., vfRY 9k2z tuV5 5W2W vFE7 qix2)
    ![image](https://github.com/danielcregg/dc-labs/assets/22198586/e0b110ed-9b6c-4149-a663-9cce2a033b4e)

    
1. Create (POST): To create a new post, send a POST request to the /index.php/wp-json/wp/v2/posts/ endpoint with the post data in the request body.  
   In postman create a POST request
    ```json
   {
    "title": "My New Post",
    "content": "This is the content of my new post",
    "status": "publish"
   }
    ```

   ![image](https://github.com/danielcregg/dc-labs/assets/22198586/4ae3e110-4be4-479e-94e6-829c0e473ae6)
   Check the response was successul. Take note of the ID of the new post you created. Now go to Wordpress and check under Posts for your new post.
   
3. Read (GET): To read a post, send a GET request to the /wp/v2/posts/<id> endpoint, where <id> is the ID of the post you want to read.
   
4. Update (POST or PUT): To update a post, send a POST or PUT request to the /wp/v2/posts/<id> endpoint with the updated post data in the request body.
5. Delete (DELETE): To delete a post, send a DELETE request to the /wp/v2/posts/<id> endpoint.
