## Spartan Weight Lifting Log

* This is an iOS application for tracking workouts.    

* The app acts as a frontend for the Rest API provided by the SpartanLog-Laravel application    
    * JSON Web Tokens are used for user authentication
    * Create, retrieve, update, and delete operations are handled asynchronously 
        * This offers a non-blocking UI    

* The rest timer was implemented using UIAlert and NSTimer     

* UIPicker was used for selecting an exercise's associated body region    

* Users can edit many-to-many relationships by toggling checked rows in UITableViews    
    * Groups and Workouts have a many-to-many relationship
    * Workouts and Exercises have a many-to-many relationship
    
Note: This is mainly meant as a learning exercise.  I would greatly appreciate feedback.    
