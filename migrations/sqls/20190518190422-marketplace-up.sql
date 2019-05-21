/* Replace with your SQL commands */

CREATE TABLE IF NOT EXISTS user_type( 
    id INT PRIMARY KEY NOT NULL,
    role VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS user(
    id VARCHAR(80) PRIMARY KEY,
    email VARCHAR(40) NOT NULL,
    account VARCHAR(80) NOT NULL,
    userType INT NOT NULL,
    uat DATETIME,
    cat DATETIME NOT NULL,
    FOREIGN KEY (userType) REFERENCES user_type(id),
);

CREATE TABLE IF NOT EXISTS farmers(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    UID VARCHAR(40) NOT NULL UINQUE,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL,
    village VARCHAR(20) NOT NULL,
    birth_date date NOT NULL
);





CREATE TABLE IF NOT EXISTS government(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
);

CREATE TABLE IF NOT EXISTS dairy_company(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
);

CREATE TABLE IF NOT EXISTS veterinarians(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    UID VARCHAR(40) NOT NULL UINQUE,
    doctor_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL,
    village VARCHAR(20) NOT NULL,
    birth_date date NOT NULL,
    contact VARCHAR(20) NOT NULL
);


INSERT INTO user_type values(1, "Farmers");
INSERT INTO user_type values(2, "Dairy");
INSERT INTO user_type values(3, "Veterians");
INSERT INTO user_type values(4, "Government");
