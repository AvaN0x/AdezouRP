CREATE TABLE IF NOT EXISTS `ban_list` (
  `steam` varchar(50) NOT NULL DEFAULT 'not_found',
  `license` varchar(50) NOT NULL,
  `discord` varchar(30) NOT NULL DEFAULT 'not_found',
  `ip` varchar(30) NOT NULL DEFAULT 'not_found',
  `xbl` varchar(30) NOT NULL DEFAULT 'not_found',
  `live` varchar(30) NOT NULL DEFAULT 'not_found',
  `name` varchar(255) NOT NULL DEFAULT 'not_found' COMMENT 'steam name of the user',
  `reason` varchar(255) NOT NULL,
  `staff` varchar(50) NOT NULL COMMENT 'steam id of the staff who banned the player',
  `ban_list` ADD `date_ban` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
