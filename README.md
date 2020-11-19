<h1><p align="center">IWS Project</p></h1>

<h5><center>Ishank Nijhawan</center></h5>

<h5><center>1710110150</center></h5>

<h3><center>Title: BookLord</center></h3>

The need of buying a brand new book is decreasing day by day as people studying for a college semester or those who are preparing for competitive exams don’t need books for that long. Some avid readers just want a book for few weeks and return them instead of purchasing it. Booklord is a mobile app which helps people buy, sell or rent used books online. 

People who buy new books find it difficult to sell it for a good price. They either ending up giving up their books to newspaper sellers to free up space in their cupboard, or sell them at a local stationery shop at a really low price.
Furthermore, those people who are looking for used books have no choice but to go to stationery shops where the shopkeeper sells those used books at a very high price.

Booklord considers the above situations and allows one on one interaction between buyer and seller without any intermediary. People can sell their used books at the price they find it reasonable and those who are looking for a used book have a variety of options to choose from, based upon book condition, price and seller location.
Through this app, we try to ease up the process of buying or selling a used book by moving the whole process online. People can browse books, sort them by price, or distance. And once they want to purchase it, they can directly chat with the buyers for further details.



## About the product

The app is made in Flutter, which is to say that it can work in both Android and iOS with one single codebase. I was only able to test it with an Android device because I don't have a Mac machine, but it will work on any iOS device just as good. For backend I've used Firebase, technically below mentioned Firebase tools

- **FirebaseAuth** for authentication and Google Sign in
- **FirebaseStorage** for storing user's profile pictures, image messages in chats and images of user's posted ads
- Firebase **Cloud Firestore** for storing user's, product's and chat data and
- Firebase **Cloud messaging** for push notifications

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
| <img src="https://user-images.githubusercontent.com/45118110/99715543-070eba00-2acd-11eb-9b0e-1c80a990223e.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99716654-63bea480-2ace-11eb-8d66-158b6244a43b.jpg" style="zoom:25%;" /> | <img src="https://user-images.githubusercontent.com/45118110/99715571-10982200-2acd-11eb-8ba6-63a8c873eafa.jpg" style="zoom:25%;" /> |

### Home Screen

Starting from home screen, there are multiple things which user can do. 