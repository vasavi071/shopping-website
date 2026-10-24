# ShopEasy – Online Shopping Website

This is an E-Commerce website built for selling products online (electronics, fashion, home essentials, sports gear and books).

## About

In this project a user can visit the website, register and log in. They can check all the products available for shopping, search items by keyword, filter them by category and then add them to the cart. They can add multiple items to the cart and also change the quantity of each item in the cart (limited to the available stock). Once the cart is updated, the user can proceed to checkout, enter the delivery address and place the order. Once the order is placed, the stock is reduced automatically and the user can see the order details in the **My Orders** section along with the order status.

The whole order placement runs as a single database transaction: if any item does not have enough stock, nothing is saved and the user is told which item is the problem.

**Note:** The checkout page is created only for learning purposes. It uses *Cash on Delivery* and is not integrated with any payment gateway.

## Highlights

- User registration and login with hashed (PBKDF2) passwords
- Product catalogue with search, category filter and product detail page
- Session-based shopping cart with plus/minus quantity update, remove and clear
- Checkout with address validation and transactional order placement
- Automatic stock reduction and out-of-stock handling
- Order history for every user
- Protected pages (`/checkout`, `/orders`) using a servlet filter
- Responsive Bootstrap 5 design with client-side and server-side validation

## Technologies Used

**Front-End Development**
- HTML
- CSS
- JavaScript
- Bootstrap 5

**Back-End Development**
- Java [JDK 11+]
- JDBC
- Servlet
- JSP (with JSTL)

**Database**
- MySQL

**Build / Server**
- Apache Maven
- Apache Tomcat 9

## Software and Tools Required

- Git (optional)
- Java JDK 11+
- Eclipse EE (Enterprise Edition) – or IntelliJ IDEA Ultimate / VS Code
- Apache Maven
- Tomcat v9.0 (Tomcat 10+ will **not** work, it uses `jakarta.*` instead of `javax.*`)
- MySQL Server
- MySQL Workbench

## Dummy Database Initialization

**STEP 1:** Open MySQL Command Prompt or MySQL Workbench.

**STEP 2:** Login to the administrator user of MySQL: `mysql -u <username> -p` (enter the password if asked).

**STEP 3:** Copy, paste and execute the MySQL queries from the following file:

`database/schema.sql`

It creates the database `shop_db`, the tables `users`, `products`, `orders`, `order_items` and inserts 12 sample products. *(The file starts with `DROP DATABASE IF EXISTS shop_db;`, so running it again wipes the old data and starts fresh.)*

## Importing and Running The Project Through Eclipse EE

**Step 1:** Open Eclipse Enterprise Edition [install it first, if not already installed].

**Step 2:** Unzip the project, then click **File > Import > Maven > Existing Maven Projects > Browse** to the project folder (the one containing `pom.xml`) **> Finish**.

**Step 3:** Go inside **src/main/resources > db.properties** and update the values as below:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/shop_db?useSSL=false&serverTimezone=Asia/Kolkata&allowPublicKeyRetrieval=true
db.username=root
db.password=your_mysql_password
```

Update `db.username` and `db.password` according to your installed MySQL credentials.

**Step 4:** Right click on Project **> Run As > Maven Build >** in the goals field enter `clean install` **> Apply > Run**.

**Step 5:** Right click on Project **> Maven > Update Project >** select *Force Update of Snapshots/Releases* **> OK** (also fix any red-marked libraries in *Build Path > Configure Build Path > Libraries*).

**Step 6:** Tomcat configuration:

If Tomcat Server is **not** configured in Eclipse:
Right click on Project > Run As > Run On Server > Manually define a new server > select **Apache > Tomcat v9.0** > (select the Tomcat installation folder if asked) > Next > add the current project > Finish.

Else if Tomcat Server is already configured in Eclipse:
Right click on Project > Run As > Run On Server > select Tomcat 9 > Next > add the project > Finish.

*or* you can directly go to the **Servers** tab, select the Tomcat server and use the Run / Debug button.

**Step 7:** Check the connection first at `http://localhost:8080/<context-path>/dbtest` – it should print `SUCCESS` and the product count.

**Step 8:** Check running the site at `http://localhost:8080/<context-path>/`

- In Eclipse the context path is the project name, e.g. `http://localhost:8080/shopping-website/`
- If you deploy the WAR file manually (`mvn clean package`, then copy `target/shop.war` into Tomcat's `webapps` folder) the address is `http://localhost:8080/shop/`
- The screenshots below were taken on port **8082** (`http://localhost:8082/shop/`).

**Step 9:** [To change the port, if you get an error like *port already in use*] Open the **Servers** tab > double click on Tomcat Server > **Ports** > change the port number for HTTP/1.1 to 8082 > Close and Save. Now start the server and open `http://localhost:8082/<context-path>/`.

**Step 10:** There is no default user. Click **Sign up** to create your own account, then log in.

## FAQ

**Question 1: Unable to connect to the database?**
Answer: Please check that MySQL is installed and running, that you have run `database/schema.sql`, and that you updated the correct username/password in `db.properties`. Then do a Maven *clean install*, force-update the project and restart the server. The `/dbtest` page shows the exact error message.

**Question 2: HTTP 404 or 500 on every page?**
Answer: Make sure you are using Tomcat **9** (not 10 or 11), that the project deployed without errors and that MySQL is running.

**Question 3: The same product appears many times on the website?**
Answer: The sample INSERT statements were executed more than once. Remove the duplicates and block them in the future:
```sql
USE shop_db;
SET SQL_SAFE_UPDATES = 0;
DELETE p1 FROM products p1 JOIN products p2 ON p1.name = p2.name AND p1.id > p2.id;
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE products ADD CONSTRAINT uq_product_name UNIQUE (name);
```

**Question 4: Order time is wrong (for example 01:55 AM instead of 8:25 PM)?**
Answer: `serverTimezone` in `db.url` must match the time zone of your MySQL server. Use `Asia/Kolkata` for India (or `UTC` if your MySQL runs in UTC).

**Question 5: Product images are not showing?**
Answer: The sample images load from the internet (the URLs are stored in the `products.image_url` column), so an internet connection is required.

**Note:** This is a sample project for learning purposes. Passwords are hashed, queries use prepared statements and output is escaped, but it has not been hardened for real production use.

## Project Structure

```
shopping-website/
├── pom.xml
├── README.md
├── screenshots/
├── database/
│   └── schema.sql
└── src/main/
    ├── resources/db.properties
    ├── java/com/shop/
    │   ├── util/     DBConnection, PasswordUtil
    │   ├── model/    Product, User, CartItem, Order, OrderItem
    │   ├── dao/      ProductDAO, UserDAO, OrderDAO
    │   ├── servlet/  Product, Cart, Login, Register, Logout, Checkout, Orders, DBTest
    │   └── filter/   AuthFilter
    └── webapp/
        ├── index.jsp, css/style.css, js/main.js
        └── WEB-INF/ web.xml, views/*.jsp (+ includes/header.jsp, footer.jsp)
```

## Database Tables

| Table | Main columns |
|-------|--------------|
| `users` | id, name, email (unique), password_hash, created_at |
| `products` | id, name, description, price, stock, category, image_url |
| `orders` | id, user_id, total, address, status, created_at |
| `order_items` | id, order_id, product_id, product_name, quantity, price |

## Some Screenshots for the project
<img width="959" height="502" alt="01-home-page" src="https://github.com/user-attachments/assets/fd417da9-4154-48df-aed2-a9ff21d0af0b" />
<img width="959" height="502" alt="02-register" src="https://github.com/user-attachments/assets/e7be0a28-28b9-44e5-97a8-e52e89e6e4b6" />
<img width="959" height="497" alt="03-login" src="https://github.com/user-attachments/assets/35143f30-9152-475f-b4c0-56a6d0644f3a" />
<img width="959" height="503" alt="04-products-logged-in" src="https://github.com/user-attachments/assets/9fbc5885-2acc-435c-83a9-cf7d791ca282" />
<img width="959" height="502" alt="05-products-grid" src="https://github.com/user-attachments/assets/dc581f16-fa3d-49b2-bbed-027fe055fdcb" />
<img width="959" height="505" alt="06-products-home-fashion" src="https://github.com/user-attachments/assets/355fea81-6256-4ce5-973d-b24611ae79e6" />
<img width="959" height="503" alt="07-products-electronics" src="https://github.com/user-attachments/assets/8127c1eb-3f89-45b1-a976-73fa0df90c36" />
<img width="955" height="499" alt="08-cart" src="https://github.com/user-attachments/assets/5912b263-f91e-43cd-ac37-711d9aefe417" />
<img width="959" height="501" alt="09-checkout" src="https://github.com/user-attachments/assets/01041e5b-e8f0-4902-9210-e26e14ff0081" />
<img width="959" height="500" alt="10-my-orders" src="https://github.com/user-attachments/assets/165cc77b-3e8c-416e-8bc5-53fa200b7253" />
