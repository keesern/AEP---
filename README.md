# TraVerse Automotive English Program
### Swift/Objective-C & JavaScript

Author : Kee Sern Chua, Levon Nie, Zou YuPeng, Xu XiaKan

OSU Automotive English Program is remolding English training for the digital learning landscape to bring you just-in-time language solutions. Providing a better end to end solution for students and instructors to interact between each other. Uses AWS the latest secure cloud service platform as the core service. Took off the project from the previous team and accomplish by the end of the semester a full functioning prototype with complete interface.

Project consist of two part, an iOS App & Web Applciation.

# iOS Backend
A completely new restructured architecture using AWS 
#### User Authentication & Access Management
##### Cognito
Custom user authentication via custom authentication process while still synchronizing user data and access AWS resources

##### IAM
To manage users identity and access management to securely control access to AWS service and resources for each users

##### S3
The app use S3 as the main object storage that use to retrieve and store data with high durability

##### Mobile Analytic
Collect precious data, measuring app usage, key trends, user retention and much more
Which data collected could be use to improve the program and app

# Web App Backend
Serverless Website
* Infinite scalability
* High availability
* Cost Efficient

#### Simple Storage Service(S3)
The HTML / CSS / JavaScript code that runs at the client-side are hosted in S3 bucket.

#### Simple Notification Service
Notify indicated user who is in the list of SNS once update event happened in S3 bucket.

#### Lambda  
Lambda executes code to call SNS service when triggered by S3 object update events. 

#### CloudFront
CloudFront is used to serve distribution work for both the media player and the media files:
* Web distribution for the media player
* RTMP distribution for the media files.






