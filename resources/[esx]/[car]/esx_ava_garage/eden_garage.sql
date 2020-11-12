ALTER TABLE `owned_vehicles` ADD `state` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Etat de la voiture' AFTER `owner`;

CREATE TABLE `user_parking` (
  `identifier` varchar(50) NOT NULL,
  `car` int(11) NOT NULL DEFAULT 2,
  `boat` int(11) NOT NULL DEFAULT 1,
  `plane` int(11) NOT NULL DEFAULT 0,
  `heli` int(11) NOT NULL DEFAULT 0,

   PRIMARY KEY (`identifier`)
)