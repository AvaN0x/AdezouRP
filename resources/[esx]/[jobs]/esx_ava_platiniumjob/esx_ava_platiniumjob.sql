INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_platinium','Platinium',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_platinium','Platinium', 1)
;

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_platinium', 'Platinium', 1)
;

INSERT INTO `inventories` (`name`, `label`, `max_weight`, `shared`) VALUES ('society_platinium', 'Platinium', '200000', '1')

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('platinium', 'Platinium', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('platinium',0,'mecano','Mécano', 0, '{"pants_2":2,"helmet_1":-1,"bags_2":0,"torso_1":66,"arms":4,"tshirt_2":0,"chain_1":0,"bproof_2":0,"shoes_1":25,"bproof_1":0,"helmet_2":1,"chain_2":0,"shoes_2":0,"bags_1":0,"pants_1":39,"torso_2":2,"tshirt_1":15}', '{}'),
    ('platinium',1,'seller','Vendeur', 0, '{"pants_2":1,"helmet_1":-1,"bags_2":0,"torso_1":4,"arms":4,"tshirt_2":0,"chain_1":0,"bproof_2":0,"shoes_1":10,"bproof_1":0,"helmet_2":1,"chain_2":0,"shoes_2":0,"bags_1":0,"pants_1":24,"torso_2":4,"tshirt_1":60}', '{}'),
    ('platinium',2,'manager','Manageur', 0, '{"pants_2":5,"helmet_1":-1,"bags_2":0,"torso_1":4,"arms":12,"tshirt_2":0,"chain_1":0,"bproof_2":0,"shoes_1":10,"bproof_1":0,"helmet_2":1,"chain_2":0,"shoes_2":0,"bags_1":0,"pants_1":24,"torso_2":5,"tshirt_1":60}', '{}'),
    ('Platinium',3,'boss','Patron', 0,'{"pants_2":0,"helmet_1":-1,"bags_2":0,"torso_1":11,"arms":11,"tshirt_2":0,"chain_1":0,"bproof_2":0,"shoes_1":10,"bproof_1":0,"helmet_2":1,"chain_2":0,"shoes_2":0,"bags_1":0,"pants_1":24,"torso_2":1,"tshirt_1":144}', '{}')
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

