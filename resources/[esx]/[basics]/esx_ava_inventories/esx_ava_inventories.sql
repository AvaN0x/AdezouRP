-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `inventories` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) NOT NULL,
  `max_weight` int(11) NOT NULL DEFAULT '100000',
  `shared` tinyint(1) NOT NULL DEFAULT '0',

  PRIMARY KEY (`name`)
);

INSERT INTO `inventories` (`name`, `label`, `max_weight`, `shared`) VALUES
('gang_ballas', 'Ballas', 100000, 1),
('gang_families', 'Families', 100000, 1),
('gang_vagos', 'Vagos', 100000, 1),
('property', 'Propriété', 100000, 0),
('inventory', 'Inventaire', 20000, 0),
('society_ammunation', 'Ammunation', 100000, 1),
('society_bahama', 'Bahamas', 100000, 1),
('society_cluckin', 'Cluckin', 100000, 1),
('society_ems', 'EMS', 100000, 1),
('society_mecano', 'Mecano', 100000, 1),
('society_nightclub', 'Galaxy', 100000, 1),
('society_police', 'LSPD', 100000, 1),
('society_state', 'Gouv', 100000, 1),
('society_tailor', 'Couturier', 100000, 1),
('society_taxi', 'Taxi', 100000, 1),
('society_unicorn', 'Unicorn', 100000, 1),
('society_vigneron', 'Vigneron', 100000, 1),
('orga_celtic', 'Celtic', 100000, 1),
('orga_ordre', 'L\'ordre', 100000, 1),
('biker_lost', 'The Lost', 100000, 1);

CREATE TABLE IF NOT EXISTS `inventories_items` (
  `name` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `identifier` varchar(50) NOT NULL DEFAULT '',

  PRIMARY KEY (`name`,`item`,`identifier`)
);