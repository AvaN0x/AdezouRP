-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


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
  `date_ban` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;