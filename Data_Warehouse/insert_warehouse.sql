-- Insert statements for the Junk table

INSERT INTO Junk (number_of_winning_places, prize_pool, entry_fee)

VALUES ('0-2', '1000 PLN', '50 PLN');



INSERT INTO Junk (number_of_winning_places, prize_pool, entry_fee)

VALUES ('1', '500 PLN', '25 PLN');



-- Insert statements for the Board_game table

INSERT INTO Board_game (name, game_category, number_of_copies, is_current)

VALUES ('Catan', 'Strategy', '50', 1);



INSERT INTO Board_game (name, game_category, number_of_copies, is_current)

VALUES ('Ticket to Ride', 'Strategy', '35', 1);



-- Insert statements for the Additional_info table

INSERT INTO Additional_info (games_rents_during_tournament, meeting_time, bringing_children, snack_and_drinks)

VALUES ('Available', '10:00 AM', 'Allowed', 'Provided');



INSERT INTO Additional_info (games_rents_during_tournament, meeting_time, bringing_children, snack_and_drinks)

VALUES ('Not available', '2:00 PM', 'Not recommended', 'Bring your own');



-- Insert statements for the Customer table

INSERT INTO Customer (name_and_surname, customer_code, age_group)

VALUES (N'Jan Kowalski', 101, N'Adult');



INSERT INTO Customer (name_and_surname, customer_code, age_group)

VALUES (N'Anna Nowak', 102, N'Teenager');



-- Insert statements for the Worker table

INSERT INTO Worker (name_and_surname, pesel)

VALUES (N'Piotr Wiœniewski', '90010112345');



INSERT INTO Worker (name_and_surname, pesel)

VALUES (N'Katarzyna Lewandowska', '85051554321');



-- Insert statements for the Date table

INSERT INTO Date (date, year, month, month_no, day_of_week, day_of_week_no)

VALUES ('2025-05-10', 2025, 'May', 5, 'Saturday', 6);



INSERT INTO Date (date, year, month, month_no, day_of_week, day_of_week_no)

VALUES ('2025-06-15', 2025, 'June', 6, 'Sunday', 7);



-- Insert statements for the Tournament_organization table

INSERT INTO Tournament_organization (worker_ID, board_game_ID, date_ID, information_ID, junk_ID)VALUES (1, 1, 1, 1, 1);INSERT INTO Tournament_organization (worker_ID, board_game_ID, date_ID, information_ID, junk_ID)VALUES (2, 2, 2, 2, 2);





-- Insert statements for the Participation table

INSERT INTO Participation (tournament_ID, customer_ID, winning_prize)

VALUES (1, 1, 500);



INSERT INTO Participation (tournament_ID, customer_ID, winning_prize)

VALUES (2, 2, 0);