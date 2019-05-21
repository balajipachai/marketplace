/* Replace with your SQL commands */

CREATE TABLE IF NOT EXISTS user_type( 
    id INT PRIMARY KEY NOT NULL,
    role VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS user(
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(36) NOT NULL,
    email VARCHAR(40) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,
    account VARCHAR(80) NOT NULL,
    userType INT NOT NULL,
    uat DATETIME,
    cat DATETIME NOT NULL,
    FOREIGN KEY (userType) REFERENCES user_type(id),
    CONSTRAINT gender CHECK (gender="male" OR gender='femail' OR gender='other')
);




INSERT INTO user_type values(1, "Farmers");
INSERT INTO user_type values(2, "Dairy");
INSERT INTO user_type values(3, "Veterians");
INSERT INTO user_type values(4, "Government");
