**Introduction** 
myFlix is a functional demo app, similar to the functionality in Netflix, that allows users to create an account, authenticate their credentials, Invite friends to join, create a queue of videos, creating/maintaining relationships with other users in the form of 'Friends', as well as Paying for a subscription. There is also an admin section that allows video's to be added to the database.

**Demo:** [http://vast-beyond-4945.herokuapp.com/](http://vast-beyond-4945.herokuapp.com/)

**Source:** [https://github.com/cachemoney/myflix-app](https://github.com/cachemoney/myflix-app)

Login as Admin or Registering a test user:

* Use CC#: 4242424242424242, CVC: 123
* Login as Admin: email: 'robin@example.com', pw: 'password'

**Goals**

I started from a mock-up with templates already coded in html and replaced sample content with data.  I used a TDD approach during development process.  Writing controller tests to flesh out a specific feature, followed by model tests, and then a feature spec(with capybara) to test interaction with multiple models and controllers.  Along with using a TDD approach, a secondary goal was to add features seen in other enterprise level web app such as:

* AWS S3 - To serve Static Assets
* Stripe for Payment/Subscription Processing
* Implementing a queue for users to track videos
* Delayed jobs(Sidekiq) to push non-critical actions into the background, making the app more responisve
* Added social features, where users can 'follow' other users.
* Tokens to anonymize data, Reset password feature, Invite a friend to Sign-up)
* Admin Section - To add more videos
* 3rd Party SMTP Integration - Mailgun to deploy System Email notifications
* Along with best Practices, like (Skinny Controller, Fat Models)

**Installation**

* git clone git@github.com:cachemoney/myflix-app.git
* cd myflix-app
* bundle install
* rake db:migrate db:seed
* foreman start

**External Dependencies**

- sqlite: for local development, postgres in production
- redis:  background processign for email notification
- smtp server: Sending out emails
- Stripe: API Keys for handling payments
- AWS S3: Hosting static assets
- Mailgun - API Keys for SMTP Server
