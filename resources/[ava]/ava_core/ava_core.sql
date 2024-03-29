-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `ava_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(64) NOT NULL,
  `discord` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `position` varchar(255) DEFAULT NULL,
  `character` text DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `loadout` text DEFAULT NULL,
  `accounts` text DEFAULT NULL,
  `status` text DEFAULT NULL,
  `jobs` text DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `last_played` boolean NOT NULL DEFAULT TRUE,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- {
--     "id": 1,
--     "license": "license:0000000",
--     "discord": "discord:0000000",
--     "name": "AvaN0x",
--     "position": "vector3(0, 0, 0)",
--     "character": {
--         "firstname": "firstname",
--         "lastname": "lastname",
--         "sex": 0,
--         "birthdate": "1970-01-01",
--         "mugshot": "data......."
--     },
--     "skin": {},
--     "loadout": {},
--     "accounts": {
--         "bank": 0
--     },
--     "status": {
--         "health": 100,
--         "armour": 0,
--         "hungry": 100,
--         "thirst": 100,
--         "drugged": 0,
--         "drunk": 0,
--         "injured": 0
--     },
--     "jobs": [
--         {
--             "name": "state",
--             "grade": "boss"
--         },
--         {
--             "name": "gang_families",
--             "grade": "og"
--         }
--     ],
--     "inventory": [
--         {
--             "name": "cash",
--             "quantity": 0
--         },
--         {
--             "name": "dirty",
--             "quantity": 0
--         },
--         {
--             "name": "bread",
--             "quantity": 1
--         }
--     ],
--     "phone_number": "012-345-6789",
--     "metadata": {},
--     "last_played": true,
--     "last_updated": "1970-01-01 00:00:00"
-- }


CREATE TABLE IF NOT EXISTS `ban_list` (
    `license` varchar(50) NOT NULL,
    `discord` varchar(30) NOT NULL DEFAULT 'not_found',
    `steam` varchar(50) NOT NULL DEFAULT 'not_found',
    `ip` varchar(30) NOT NULL DEFAULT 'not_found',
    `xbl` varchar(30) NOT NULL DEFAULT 'not_found',
    `live` varchar(30) NOT NULL DEFAULT 'not_found',
    `name` varchar(255) NOT NULL DEFAULT 'not_found' COMMENT 'name of the user',
    `reason` varchar(255) NOT NULL,
    `staff` varchar(50) NOT NULL COMMENT 'discord id of the staff who banned the player',
    `date_ban` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE IF NOT EXISTS `ava_jobs` (
  `name` varchar(50) NOT NULL,
  `accounts` text DEFAULT NULL,
  `salaries` text DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE IF NOT EXISTS `ava_named_inventories` (
    `name` varchar(128) NOT NULL,
    `label` varchar(50) NOT NULL,
    `max_weight` int(11) NOT NULL DEFAULT 500000,
    `inventory` longtext DEFAULT NULL,
    `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_named_inventories_id PRIMARY KEY (`name`),
    CONSTRAINT CHK_named_inventories_max_weight CHECK(`max_weight` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE IF NOT EXISTS `ava_vehiclestrunk` (
    `vehicleid` int NOT NULL,
    `max_weight` int(11) NOT NULL DEFAULT 30000,
    `trunk` longtext NOT NULL,
    `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_vehiclestrunk_id PRIMARY KEY (`vehicleid`),
    CONSTRAINT FK_vehiclestrunk_vehicles_vehicleids FOREIGN KEY(`vehicleid`) REFERENCES `ava_vehicles`(`id`) ON DELETE CASCADE,
    CONSTRAINT CHK_vehiclestrunk_max_weight CHECK(`max_weight` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;