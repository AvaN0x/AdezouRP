INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_bahama','Bahama',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_bahama','Bahama', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_bahama', 'Bahama', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('bahama', 'Bahama', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('bahama',0,'employe','Employe', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('bahama',1,'boss','Patron', 500,'{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}')
;


INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	-- ('raisin', 'Raisin', 180),
	-- ('jus_raisin', 'Jus de raisin', 18),
	-- ('vine', 'Vin', 18),
	-- ('champagne', 'Champagne', 18),
	-- ('grand_cru', 'Grand Cru', 18),
	-- ('woodenbox', 'Caisse en bois', 150),
	-- ('vinebox', 'Caisse de vin', 20),
	-- ('jus_raisinbox', 'Caisse de Jus de raisin', 20),
	-- ('champagnebox', 'Caisse de Champagne', 20),
	-- ('grand_crubox', 'Caisse de Grand Cru', 20)
;

