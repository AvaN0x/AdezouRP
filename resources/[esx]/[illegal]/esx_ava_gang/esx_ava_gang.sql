INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUE
	('gang_cartel','Cartel', 1),
	('gang_cartel_black','Cartel', 1),
	('gang_marabunta','Marabunta', 1),
	('gang_marabunta_black','Marabunta', 1),
	('gang_vagos','Vagos', 1),
	('gang_vagos_black','Vagos', 1),
	('gang_ballas','Ballas', 1),
	('gang_ballas_black','Ballas', 1),
	('gang_families','Families', 1),
	('gang_families_black','Families', 1),
	('orga_celtic','Celtic', 1),
	('orga_celtic_black','Celtic', 1),
	('orga_ordre','L\'ordre', 1),
	('orga_ordre_black','L\'ordre', 1),
	('biker_lost','The Lost', 1),
	('biker_lost_black','The Lost', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
    ('gang_cartel','Cartel', 1),
    ('gang_marabunta','Marabunta', 1), 
	('gang_vagos','Vagos', 1),
	('gang_ballas','Ballas', 1),
	('gang_families','Families', 1),
	('orga_celtic','Celtic', 1),
	('orga_ordre','L\'ordre', 1),
	('biker_lost','The Lost', 1)
;

CREATE TABLE `user_gang` (
	`identifier` varchar(50) NOT NULL,
	`name` varchar(50) NOT NULL,
	`grade` int(2) NOT NULL DEFAULT '0',

	PRIMARY KEY (`identifier`)
);
