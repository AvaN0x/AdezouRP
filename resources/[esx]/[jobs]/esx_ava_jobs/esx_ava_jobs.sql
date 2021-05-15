CREATE TABLE `user_pickups_count` (
    `count` int(3) NOT NULL,
    `illegalCount` int(3) NOT NULL,
    `identifier` varchar(50) NOT NULL,

    PRIMARY KEY (`identifier`)
);

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
    -- vigneron
    ('society_vigneron','Vigneron',1),

    -- tailor
    ('society_tailor','Couturier',1),

    -- cluckin
	('society_cluckin','Cluckin Bell',1),

;

INSERT INTO `inventories` (`name`, `label`, `max_weight`, `shared`) VALUES
    -- vigneron
    ('society_vigneron', 'Vigneron', 500000, 1),

    -- tailor
    ('society_tailor', 'Couturier', 500000, 1),

    -- cluckin
	('society_cluckin','Cluckin Bell', 1),

;

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
    -- vigneron
	('society_vigneron', 'Vigneron', 1),

    -- tailor
	('society_tailor', 'Couturier', 1),

    -- cluckin

;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
    -- vigneron
	('vigneron', 'Vigneron', 1),

    -- tailor
	('tailor', 'Couturier', 1),

    -- cluckin
	('cluckin', 'Cluckin Bell', 1),

;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    -- vigneron
    ('vigneron',0,'interim','Intérimaire', 100, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('vigneron',1,'employe','Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('vigneron',2,'chef','Chef', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('vigneron',3,'boss','Patron', 500,'{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),

    -- tailor
	('tailor',0,'interim','Intérimaire', 50, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('tailor',1,'employe','Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('tailor',2,'chef','Chef', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('tailor',3,'boss','Patron', 500,'{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),

    -- cluckin
	('cluckin',0,'employe','Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('cluckin',1,'chef','Chef', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('cluckin',2,'boss','Patron', 500,'{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),

;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
    -- vigneron
	('raisin', 'Raisin', 180),
	('jus_raisin', 'Jus de raisin', 18),
	('vine', 'Vin', 18),
	('champagne', 'Champagne', 18),
	('grand_cru', 'Grand Cru', 18),
	('woodenbox', 'Caisse en bois', 150),
	('vinebox', 'Caisse de vin', 20),
	('jus_raisinbox', 'Caisse de Jus de raisin', 20),
	('champagnebox', 'Caisse de Champagne', 20),
	('grand_crubox', 'Caisse de Grand Cru', 20),

    -- tailor
    ('wool', 'Laine', 180),
	('fabric', '🧵 Tissu', 72),
	('clothe', '👔 Vêtement', 36),
	('cardboardbox', 'Boite en carton', 20),
	('clothebox', 'Boite de vêtements', 20)

    -- cluckin
	('alive_chicken', 'Poule en cage', 20),
	('plucked_chicken', 'Poulet déplumé', 20),
	('raw_chicken', 'Poulet cru', 160),
	('nuggets', 'Boite de nuggets', 20),
	('chickenburger', 'Chicken Burger', 20),
	('frites', 'Frites', 20),
	('sprite', 'Sprite', 20),
	('orangina', 'Orangina', 20),
	('potato', 'Patate', 20),

	('doublechickenburger', 'Double Chicken Burger', 20),
	('potatoes', 'Potatoes', 20),
	('tenders', 'Tenders', 20),
	('chickenwrap', 'Wrap au poulet', 20),

    -- unicorn
	('orange', '🍊 Orange', -1)


;


INSERT INTO `vehicles_society`(`name`, `model`, `price`, `society`) VALUES 
    ('Benson', 'benson', 200000, 'society_cluckin'),
    ('FoodTruck', 'taco', 200000, 'society_cluckin')

;