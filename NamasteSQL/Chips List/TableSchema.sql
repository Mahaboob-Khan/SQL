-- DDL Script to CREATE & load the data into TABLE
CREATE TABLE Chips_tbl (
  Chips VARCHAR(500),
  Amount VARCHAR(500)
);

INSERT INTO Chips_tbl(Chips, Amount) VALUES
('lays1, uncle_chips1, kurkure1', '10,20,30'),
('wafferrs2', '40,50'),
('potatochips3, hotchips3, balaji3', '60,70,80');