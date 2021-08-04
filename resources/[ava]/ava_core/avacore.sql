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
  `loadout` longtext DEFAULT NULL,
  `accounts` text DEFAULT NULL,
  `status` text DEFAULT NULL,
  `jobs` text DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `last_played` boolean NOT NULL DEFAULT TRUE,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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