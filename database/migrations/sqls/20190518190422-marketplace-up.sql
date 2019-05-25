/* Replace with your SQL commands */

CREATE TABLE IF NOT EXISTS user_type( 
    id INT PRIMARY KEY NOT NULL,
    role VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS user(
    id VARCHAR(80) PRIMARY KEY,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(80) NOT NULL,
    ethereum_account VARCHAR(80) NOT NULL,
    userType INT NOT NULL,
    FOREIGN KEY (userType) REFERENCES user_type(id)
);

CREATE TABLE IF NOT EXISTS farmers(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    UID VARCHAR(40) NOT NULL UNIQUE,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_line VARCHAR(30) NOT NULL,
    state VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL,
    village VARCHAR(20) NOT NULL,
    birth_date date NOT NULL
);

CREATE TABLE IF NOT EXISTS government(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    gov_org_name VARCHAR(40) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    address_line VARCHAR(30) NOT NULL,
    state VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS dairy_company(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    org_name VARCHAR(40) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_line VARCHAR(40) NOT NULL,
    state VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS veterinarians(
    userId VARCHAR(80) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(id),
    UID VARCHAR(40) NOT NULL UNIQUE,
    doctor_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_line VARCHAR(40) NOT NULL,
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
