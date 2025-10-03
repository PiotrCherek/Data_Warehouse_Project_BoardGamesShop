USE warehouse
GO
CREATE TABLE Junk (
	junk_ID INT IDENTITY(1,1) PRIMARY KEY,
	number_of_winning_places VARCHAR(20),
	prize_pool VARCHAR(20),
	entry_fee VARCHAR(10)
);

CREATE TABLE Board_game (
	game_ID INT IDENTITY(1,1) PRIMARY KEY,
	game_name NVARCHAR(50),
	game_category NVARCHAR(50),
	number_of_copies VARCHAR(30),
	is_current BIT
);

CREATE TABLE Additional_info (
	information_ID INT IDENTITY(1,1) PRIMARY KEY,
	games_rents_during_tournament VARCHAR(60),
	meeting_time VARCHAR(60),
	bringing_children VARCHAR(60),
	snack_and_drinks VARCHAR(60),
);

CREATE TABLE Customer (
    customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    name_and_surname NVARCHAR(100),
    customer_code INT,
    age_group NVARCHAR(20)
);

CREATE TABLE Worker (
    worker_ID INT IDENTITY(1,1) PRIMARY KEY,
    name_and_surname NVARCHAR(100),
    pesel VARCHAR(12)
);

CREATE TABLE Date (
    date_ID INT IDENTITY(1,1) PRIMARY KEY,
    date DATE,
    year INT,
    month NVARCHAR(10),
	month_no INT,
    day_of_week NVARCHAR(10),
    day_of_week_no INT
);

CREATE TABLE Tournament_organization (
	tournament_ID INT IDENTITY(1,1) PRIMARY KEY,
	worker_ID INT,
	board_game_ID INT,
	date_ID INT,
	information_ID INT,
	junk_ID INT
	CONSTRAINT FK_worker FOREIGN KEY (worker_ID) REFERENCES Worker(worker_ID),
	CONSTRAINT FK_board_game FOREIGN KEY (board_game_ID) REFERENCES Board_game(game_ID),
	CONSTRAINT FK_date FOREIGN KEY (date_ID) REFERENCES Date(date_ID),
	CONSTRAINT FK_information FOREIGN KEY (information_ID) REFERENCES Additional_info(information_ID),
	CONSTRAINT FK_junk FOREIGN KEY (junk_ID) REFERENCES Junk(junk_ID),
);

CREATE TABLE Participation (
    participation_ID INT IDENTITY(1,1) PRIMARY KEY,
	tournament_ID INT,
	customer_ID INT,
	winning_prize INT,
	CONSTRAINT FK_Tournament FOREIGN KEY (tournament_ID) REFERENCES Tournament_organization(tournament_ID),
	CONSTRAINT FK_Customer FOREIGN KEY (customer_ID) REFERENCES Customer(customer_ID),
);

-- CONSTRAINT FK_TournamentParticipants_Customer_ID FOREIGN KEY (Customer_ID) 
-- REFERENCES CustomerAccountInfo(Customer_Code),
