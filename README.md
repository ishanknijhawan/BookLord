<h1><p align="center">BookLord</p></h1>

Download the app from [here](https://drive.google.com/file/d/1tkp1OXflFCc4peFx3mF5z7tJvo9CvRGk/view?usp=sharing)

[TOC]

## Motivation

The need of buying a brand new book is decreasing day by day as people studying for a college semester or those who are preparing for competitive exams don’t need books for that long. Some avid readers just want a book for few weeks and return them instead of purchasing it. Booklord is a mobile app which helps people buy, sell or rent used books online. 

People who buy new books find it difficult to sell it for a good price. They either ending up giving up their books to newspaper sellers to free up space in their cupboard, or sell them at a local stationery shop at a really low price.
Furthermore, those people who are looking for used books have no choice but to go to stationery shops where the shopkeeper sells those used books at a very high price.

Booklord considers the above situations and allows one on one interaction between buyer and seller without any intermediary. People can sell their used books at the price they find it reasonable and those who are looking for a used book have a variety of options to choose from, based upon book condition, price and seller location.
Through this app, we try to ease up the process of buying or selling a used book by moving the whole process online. People can browse books, sort them by price, or distance. And once they want to purchase it, they can directly chat with the buyers for further details.

## About the product

The app is made in Flutter, which is to say that it can work in both Android and iOS with one single codebase. I was only able to test it with an Android device because I don't have a Mac machine, but it will work on any iOS device just as good. For backend I've used Firebase, and all the below mentioned tools for making this application.

### <u>Technologies Used</u>

- Google **Flutter SDK** for the frontend part. 
- Flutter packages like Location, Provider, firebase and camera.
- **FirebaseAuth** for authentication and Google Sign in
- **FirebaseStorage** for storing user's profile pictures, image messages in chats and images of user's posted ads
- Firebase **Cloud Firestore** for storing user's, product's and chat data and
- Firebase **Cloud messaging** for push notifications
- Firebase **Cloud Functions** for deploying notification code to server side.
- **Google Cloud platform** for showing maps and place names

The app starts with an Authentication screen as shown below

| Sign in screen                                                                                                                       | Login screen                                                                                                                         | Google sign In                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99714820-0fb2c080-2acc-11eb-94bb-87531f909d57.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99714838-13dede00-2acc-11eb-9d58-68275b7e1c1d.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99714852-18a39200-2acc-11eb-9e05-0946bd303654.jpg" style="zoom:25%;" /> |



Once the user is logged in, he/she is greeted with 5 tabs, viz

1. Home Screen
2. MyAds Screen

- Posted Ads
- Favourite Ads

3. Add a book screen

4. Chat Screen

5. Profile screen

All the screens are shown below

| Home Screen                                                                                                                          | Posted Ads Screeen                                                                                                                   | Favourite Ads Screeen                                                                                                                |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99715513-fc542500-2acc-11eb-9244-3a6974d1f62f.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99716666-66b99500-2ace-11eb-9daf-d31439c99bf3.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99715528-037b3300-2acd-11eb-81db-0a999b468373.jpg" style="zoom:25%;" /> |
| **Add new ad Screen**                                                                                                                | **Chat Screen**                                                                                                                      | **Profile Screen**                                                                                                                   |
| <img src="https://user-images.githubusercontent.com/45118110/99715543-070eba00-2acd-11eb-9b0e-1c80a990223e.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99902922-19fcd680-2ce7-11eb-8b6e-b7ab9041145a.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99715571-10982200-2acd-11eb-8ba6-63a8c873eafa.jpg" style="zoom:25%;" /> |

### <u>Home Screen followd by Product detail Screen</u> 

Starting from home screen, there are multiple things which user can do. He can mark/unmark ads as favorites. He can open the ads for more information like how far the person lives from his location, what is the condition of the book. He can also chat with the user from the app itself. If the user is opening his own ad, he can delete the ad or mark his ad as Sold. Below are the screens for the same. 

| Asking for location                                                                                                                  | Product Info Screen                                                                                                                  | Search Screen                                                                                                                        |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99717497-7ab1c680-2acf-11eb-8b8f-7423b7f1fe71.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99717509-7dacb700-2acf-11eb-8122-5c3d6c97faa7.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99902924-1c5f3080-2ce7-11eb-8e18-6d72fcfd8df2.jpg" style="zoom:25%;" /> |
| **Sort products**                                                                                                                    | **Mark ad as Sold**                                                                                                                  | **Delete ad**                                                                                                                        |
| <img src="https://user-images.githubusercontent.com/45118110/99902926-1f5a2100-2ce7-11eb-83ab-15df167dc392.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99717580-95843b00-2acf-11eb-9d20-e5292202223b.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99717586-987f2b80-2acf-11eb-9b74-2bdfd4c431b4.jpg" style="zoom:25%;" /> |

### <u>Add Product Screen</u>

From this screen, user can follow the steps for posting an ad. The first 2 screens asks what kind of books the user wants to sell. The next two screens asks the user about the book details and some images he wants to share. User can add upto 3 images either from the camera or from his gallery. The final screens asks the price the user wants to set and the location where the user lives. There are two options are, first is user can choose current location by just tapping the  current location button, second option allows user to select any location by pinning his location on the map (shown below) User can also **Donate** ❤ the book by pressing at the heart icon. Once the user has posted his ad, it will appear on the home screen of every other user.  

| Add Books Screen                                                                                                                      | Further Categories Screen                                                                                                             | Book details                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99903258-4fa2bf00-2ce9-11eb-93f4-3ae1e5c8b771.jpg" style="zoom:25%;" />  | <img src="https://user-images.githubusercontent.com/45118110/99718485-f06a6200-2ad0-11eb-93bf-54bbbc103814.jpg" style="zoom:25%;" />  | <img src="https://user-images.githubusercontent.com/45118110/99718494-f4967f80-2ad0-11eb-803c-71b980dae8c0.jpg" style="zoom:25%;" /> |
| **Adding images screen**                                                                                                              | **Image from Camera**                                                                                                                 | **Image from Gallery**                                                                                                               |
| <img src="https://user-images.githubusercontent.com/45118110/99718516-feb87e00-2ad0-11eb-96a4-046437802a5e.jpg" style="zoom:25%;" />  | <img src="https://user-images.githubusercontent.com/45118110/99718960-afbf1880-2ad1-11eb-9229-36cc7266f4ec.jpg" style="zoom:25%;" />  | <img src="https://user-images.githubusercontent.com/45118110/99718963-b3529f80-2ad1-11eb-8f68-747f15c56404.jpg" style="zoom:25%;" /> |
| **Price and Location screen**                                                                                                         | **Custom Location**                                                                                                                   |                                                                                                                                      |
| <img src="https://user-images.githubusercontent.com/45118110/100059614-62380800-2e51-11eb-9cab-2b7a86a3b1bf.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/100059648-6e23ca00-2e51-11eb-860e-3f9fdd9478c7.jpg" style="zoom:25%;" /> |                                                                                                                                      |

### <u>Chat Screen</u>

The app also has chat feature built in so that users don't have to share their phone number in the app. Buyers can just directly chat with the seller and with the push notifications, the seller is immediately notified. Image messages are also supported in the chat screen and the seller can just share some more pics of the book on buyer's demand. 

| Chat Screen                                                                                                                          | Image messages                                                                                                                       | Push Notifications                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99903482-ba082f00-2cea-11eb-8692-587825067308.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99717556-9026f080-2acf-11eb-883d-8c8d667204cc.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99719616-8ce13400-2ad2-11eb-9b3f-92dbb9633011.jpg" style="zoom:25%;" /> |



### <u>Dark Mode</u>

Last but not the least. I've also added a dark mode feature which might come in handy for some users. Below are the screenshots of some screens in dark mode. 

| Product detail Screen                                                                                                                | Add Product Screen                                                                                                                   | Chat Screen                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/45118110/99903255-4dd8fb80-2ce9-11eb-8ae1-71f6ace214c0.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99903251-4b76a180-2ce9-11eb-9b64-30f4ba0ce4de.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99903253-4d406500-2ce9-11eb-8f29-e48fb6539320.jpg" style="zoom:25%;" /> |

## Conclusion and Further imrovements

To conclude, I'd like to say that this can be very useful app for all those people who are looking for a used book for any reason like preparation for competetive exam, want a novel and return it, or browse any other book which they might like. For further improvements, I'd like to implement a payment system inside the app. This might come in handy because in today's times where cash exchange can be dangerous, buyer can just pay instantly to the seller without any physical contact of cash. I'd also like to improve upon some features like category selection, where user can filter the products based upon the category like novels, educational books,  competetive exam books, etc. 
