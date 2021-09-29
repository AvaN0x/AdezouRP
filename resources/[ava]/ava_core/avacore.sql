-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

CREATE TABLE IF NOT EXISTS `players` (
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
  `metadata` longtext DEFAULT NULL,
  `last_played` boolean NOT NULL DEFAULT TRUE,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
--         "birthdate": "1970-01-01"
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
--     "metadata": {
--         "phone": "555-1234"
--     },
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `accounts` text DEFAULT NULL,
  `salaries` text DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
