USE `essentialmode`;

CREATE TABLE `shops` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`store` varchar(100) NOT NULL,
	`item` varchar(100) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `shops` (store, item, price) VALUES
	('TwentyFourSeven','bread',30),
	('TwentyFourSeven','water',15),
	('RobsLiquor','bread',30),
	('RobsLiquor','water',15),
	('LTDgasoline','bread',30),
	('LTDgasoline','water',15)
;

INSERT INTO `shops` (`store`, `item`, `price`) VALUES
	('Ammunation', 		'clip', 200),
	('Ammunation', 		'weapon_bat', 750),
	('Ammunation', 		'weapon_battleaxe', 1800),
	('Ammunation', 		'weapon_machette', 1500),
	('Ammunation', 		'weapon_switchblade', 2200),
	('Ammunation', 		'weapon_knife', 2000),
	('Ammunation', 		'gadget_parachute', 5000),
	('Ammunation', 		'weapon_flare', 3000),
	('Ammunation', 		'weapon_pistol', 20000),
	('Ammunation', 		'weapon_doubleaction', 100000),
	('LTDgasoline', 	'weapon_flashlight', 700),
	('RobsLiquor', 		'weapon_flashlight', 700),
	('TwentyFourSeven', 'weapon_flashlight', 700)
;

INSERT INTO `shops` (`store`, `item`, `price`) VALUES
	('BlackMarket', 'lockpick', 2000),
	('BlackMarket', 'balisegps', 3000),
	('BlackMarket', 'tenuecasa', 5000),
	('BlackMarket', 'headbag', 2000)
;